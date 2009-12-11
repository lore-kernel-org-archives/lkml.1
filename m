Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZLKPbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZLKPbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbZLKPbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:31:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:43019 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538AbZLKPbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:31:20 -0500
Message-ID: <4B2265D2.6000400@suse.cz>
Date: Fri, 11 Dec 2009 16:31:30 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/3] Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200912080317.08254.rob@landley.net> <200912091740.43147.rob@landley.net> <4B20FD2C.1010804@suse.cz> <200912101717.00049.rob@landley.net>
In-Reply-To: <200912101717.00049.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Thursday 10 December 2009 07:52:44 Michal Marek wrote:
>> and the makefile would run timeconst.pl to generate timeconst_custom.h
>> iff HZ is set to something arbitrary. I don't have a patch for that, but
>> I don't see a fundamental problem with such approach.
> 
> I looked at that when I was attempting to update (rather than replace) my 
> original patch.  There's a reason I didn't go there.  You're suggesting there 
> be two code paths, one maintained by hand and the other just about never 
> tested against bit-rot.

OK, that's valid point, indeed. Peter, would you ack Rob's patch with
the oneline fix added (http://lkml.org/lkml/2009/12/8/94 plus
http://lkml.org/lkml/2009/12/9/435)?

Michal
