Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZIXRdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZIXRdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZIXRdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:33:11 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54883 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZIXRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=mU+ZuGjMQmyXUT26RoiZhgO4Oa+SCRb/TDOya9bBuoe0vilITOhjRpsDJ5X7Y2qbEn
         VmeqywTweaGwddhC8REfAL6muF0h3A+8RQj+e5SO+6MrZ2cxYo77jwxVFawhi0mSc6ao
         gvaLiE8vxDlLa7TEujhoJPtBO1Tx848MPYAQo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: whansard@sbcglobal.net
Subject: Re: disk speed regression kernel 2.6.29 and after
Date: Thu, 24 Sep 2009 19:34:27 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-07381-g7fa0772-dirty; KDE/4.3.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4ABA0FDA.9090707@sbcglobal.net> <200909241426.49947.bzolnier@gmail.com> <20090924112645.dc97dd07.whansard@sbcglobal.net>
In-Reply-To: <20090924112645.dc97dd07.whansard@sbcglobal.net>
MIME-Version: 1.0
Message-Id: <200909241934.27472.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 September 2009 18:26:45 Will wrote:
> On Thu, 24 Sep 2009 14:26:49 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > 
> > 
> > I don't see how could commit 295f00 be the guilty one here.  I'm suspecting
> > that bisection went wrong at some point (easy to verify by checking if commit
> > 295f00^1 is also bad).
> > 
> > PS Will, it would be useful to try libata first and possibly rule out PATA out
> > of the picture completely.
> 
> Disabling "ATA/ATAPI/MFM/RLL"  restored my performance completely, with the
> newer kernels. I'll just have to get used my other hard drives being sdb . . ..
> Thanks guys.  The copy takes right at 3m30s now.
> I made a change to dd years ago to make it default to 1 meg block size and to show
> me the "Megs copied" on screen, so I can watch how fast dd is going.  With the 
> older atapi drivers, this copy would be fast, but jerky and halting. With kernel
> 2.6.29 and after the halts were more frequent and longer, dragging the copy out
> to over 9 minutes in this case.  With only the libata enabled, the "megs copied"
> is very smooth, with no halting, though still right at 3m30s.
> If you need me to test anything for the sake of the older drivers, I can.
> Thanks again for the help.

I'm glad to hear that the issue is fixed for you.

Regarding additional pursue of the root cause, I think that it is not worth
the effort currently since there were no other reports about similar problems
and libata is a better solution on most modern systems anyway.
