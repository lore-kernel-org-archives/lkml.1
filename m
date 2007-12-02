Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbXLBUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbXLBUxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbXLBUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:53:39 -0500
Received: from uruk.org ([71.39.5.49]:32830 "EHLO uruk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbXLBUxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:53:38 -0500
X-Greylist: delayed 1929 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Dec 2007 15:53:38 EST
To: linux-kernel@vger.kernel.org
Subject: Patch works! (was Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3)
Date: Sun, 02 Dec 2007 12:21:28 -0800
From: Erich Boleyn <erich@uruk.org>
Message-Id: <E1IyvJg-0002Ax-2i@uruk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Summary:  I couldn't find any further responses confirming the patch
worked, so I thought I'd report that it does work for my case which
was very similar.  See Below for details.

NOTE: I am not subscribed, so make sure I'm copied on any replies.

David CHANIAL wrote:

> Le Tuesday 04 September 2007 01:55:57 Satyam Sharma, vous avez :
> 
> > Did you test with that patch applied? Did you manage to hit the
> > BUG again (with or without it)?
> 
> I not have tested this patch.
> 
> I will test it as soon as possible (in few days).
> 
> Best regards,
> -- 
> David


I have had a similar OOPS problem on an x86-64 SMP server box of mine
with a MacOS X (10.4.x) client since switching to 2.6.22.x (several
versions).  I found your messages on LKML and have applied the patch.

My symptom was the oops after approximately 1/2 to 1 day of continous
activity (iTunes playing long playlist), very reproducible.

After applying the patch in an earlier message in the thread (LKML
message archive URL "http://lkml.org/lkml/2007/7/20/38"), I have had
my test running for 3 days straight now with no signs of problems.

Thanks for the great work!


--
    Erich Stefan Boleyn     <erich@uruk.org>     http://www.uruk.org/
"Reality is truly stranger than fiction; Probably why fiction is so popular"
