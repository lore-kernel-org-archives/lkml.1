Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYBGJTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYBGJTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYBGJS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:18:57 -0500
Received: from twin.jikos.cz ([213.151.79.26]:60341 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbYBGJSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:18:55 -0500
Date: Thu, 7 Feb 2008 10:18:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <1202318666.6406.13.camel@popeye>
Message-ID: <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
 <1202318666.6406.13.camel@popeye>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Chris Holvenstot wrote:

> I have several hours of running aith nohpet and X's affinity set to 2
> instead of 3 and so far everything is running flawlessly.

Great, so this definitely is some kind of timing issue, thanks for 
verifying that.

> which has the same suggestion (taskset) as you made, for me this was 
> something new starting with 2.6.24-git15 - maybe something made a timing 
> issue fall a little closer to the edge.

Yes, could be some scheduler update that made the problem more visible. If 
you'd had time to use git-bisect to find the exact commit that exposes 
your problem, that might be interesting. But as you said that this is not 
immediately reproducible, it might take ages.

> Would you like me to try and further isolate things for you here by 
> either running with just nohpet OR just the taskset to change X's 
> affinity?

Yes, that would help. Especially knowing whether running with 'nohpet' 
fixes the problem would be nice.

-- 
Jiri Kosina
SUSE Labs
