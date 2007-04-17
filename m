Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXDQJ2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXDQJ2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXDQJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:28:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:14652 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbXDQJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z5SWniTExw3pwyULcoxDs+zbWbtVxcSsKitwbbXDSfPxIMEUOi6gc8SftoMqgWe7igJ8bJcREp0YDwzVp/intK6zYehwfo5OU+3FmJIQLKGt/OVEjbjEMzE2akhRnTnQBchugWIha9ByXgTDvk6IS68cgkftlU7xIbiP4Rlrp9E=
Subject: Re: [3/3] 2.6.21-rc6: known regressions
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Marcus Better <marcus@better.se>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <200704171017.07012.marcus@better.se>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <200704160823.39074.marcus@better.se> <1176705924.5129.1.camel@daplas>
	 <200704171017.07012.marcus@better.se>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 17:27:56 +0800
Message-Id: <1176802076.6227.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 10:17 +0200, Marcus Better wrote:
> > Have you tried other combinations?
> >
> > s2ram -m -p -f
> > s2ram -s -p -f
> 
> Yes, I tried these slightly different combinations:
> 
> s2ram -f -a3 -s: Works! The screen becomes green but is restored quickly. It 
> prints the following messages:
> Allocated buffer at 0x11000 (base is 0x0)
> ES: 0x1100 EBX: 0x0000
> Save video state failed
> Calling restore_state_from
> Function not supported?
> Restore video state failed
> Switching back to vt1
> 
> s2ram -f -a3 -p: Screen goes green and then blank. Everything hangs, doesn't 
> react to keyboard input.
> 
> s2ram -f -a3 -m: Works!
> 

Thanks.  Should we consider this regression resolved?  There is really
nothing much vesafb can do to restore its previous state, except through
the use of userland tools.

Tony


