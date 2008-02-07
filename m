Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbYBGKlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbYBGKlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYBGKl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:41:28 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:57172 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbYBGKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:41:27 -0500
X-Authority-Analysis: v=1.0 c=1 a=yfaj0FAMEn1KDdGR7eIA:9
 a=W5IOY979deS4bXy4zesA:7 a=5AVYvaYdAlAS_HsLGYb1dwoLy18A:4 a=uv1ck3d6JtEA:10
Subject: Re: 2.6.24-git15 Keyboard Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
References: <1202302978.9058.13.camel@popeye>
	 <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
	 <1202305740.9058.22.camel@popeye>
	 <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
	 <1202318666.6406.13.camel@popeye>
	 <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Date: Thu, 07 Feb 2008 04:44:54 -0600
Message-Id: <1202381094.6179.0.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri - 


I have been up and running now for about a half hour – since I did not
hear your preference I stayed with git15 instead of jumping up to git16
in an attempt to avoid introducing any unwanted changes.


The only non-standard thing I did was to use the nohpet directive at
boot time - I did NOT enter the previously used taskset command to alter
X's affinity. 


I have been banging away on my keyboard for about a half hour now with
no problems. While this is not conclusive on a 'soft' problem, from what
I experienced yesterday I would have expected to have seen the problem
by now.


Please let me know if there are any other items you would like to do or
options you would like me to try.


Chris



On Thu, 2008-02-07 at 10:18 +0100, Jiri Kosina wrote:
> On Wed, 6 Feb 2008, Chris Holvenstot wrote:
> 
> > I have several hours of running aith nohpet and X's affinity set to 2
> > instead of 3 and so far everything is running flawlessly.
> 
> Great, so this definitely is some kind of timing issue, thanks for 
> verifying that.
> 
> > which has the same suggestion (taskset) as you made, for me this was 
> > something new starting with 2.6.24-git15 - maybe something made a timing 
> > issue fall a little closer to the edge.
> 
> Yes, could be some scheduler update that made the problem more visible. If 
> you'd had time to use git-bisect to find the exact commit that exposes 
> your problem, that might be interesting. But as you said that this is not 
> immediately reproducible, it might take ages.
> 
> > Would you like me to try and further isolate things for you here by 
> > either running with just nohpet OR just the taskset to change X's 
> > affinity?
> 
> Yes, that would help. Especially knowing whether running with 'nohpet' 
> fixes the problem would be nice.
> 

