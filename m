Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZIXQ0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZIXQ0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZIXQ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:26:43 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:46473 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751732AbZIXQ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:26:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Date:From:To:Subject:Message-Id:In-Reply-To:References:Reply-To:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=Nkt6Lbwh/jBmUFDLFv5mn5J+WPJyZAZq3/Zl2Myz2eC2QfS4zj5BfQKo3TAQImu7SGS6kbt3x5XG1kBWfHqeVg0duoZ2W4C4oOT0WCPZd0RHwV0GB6M2CcNhApDRI8CNXbYcSQB851lrKPRBuSA0Z8kNjN0XTMUD7ZTaSvpN/5c=  ;
X-YMail-OSG: b8Bt7BoVM1nm2Z1fEyjpytps0SNRRXi1k7wnkGxhfRJzIfVptOyTIpMt6.Q3mPAXkfCY_uLUle5fFWOOgRAPJqIfMlyzTPpCu2Yx6sa9Ac.WCP7WUq6k3ECUgwamS3cl6dvgHiqRME58aQfn4WNypJ0ySX8ccULhLkueNMQz6V02eFQOLUHTSRRsAsUkrvsUVzymrOb.QGeO.53ZEyg1qssvdqN3CWAAEnZBlYKVMJd8J7u_2D84ivQ0.74dmPzjpPsd1cfCZ4UsRwSj0ZYttvnAMOiGRvdQaTpM0mEx8_0Z.9Lnh8EZ9dGfCSB7rUev1VEkKqTcdEBjBxi12H.L
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Sep 2009 11:26:45 -0500
From: Will <whansard@sbcglobal.net>
To: linux-kernel@vger.kernel.org
Subject: Re: disk speed regression kernel 2.6.29 and after
Message-Id: <20090924112645.dc97dd07.whansard@sbcglobal.net>
In-Reply-To: <200909241426.49947.bzolnier@gmail.com>
References: <4ABA0FDA.9090707@sbcglobal.net>
	<20090923233505.a567667b.whansard@sbcglobal.net>
	<20090924094447.16137esujpct2bfz@webmail.cs.aau.dk>
	<200909241426.49947.bzolnier@gmail.com>
Reply-To: whansard@sbcglobal.net
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 14:26:49 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> 
> I don't see how could commit 295f00 be the guilty one here.  I'm suspecting
> that bisection went wrong at some point (easy to verify by checking if commit
> 295f00^1 is also bad).
> 
> PS Will, it would be useful to try libata first and possibly rule out PATA out
> of the picture completely.

Disabling "ATA/ATAPI/MFM/RLL"  restored my performance completely, with the
newer kernels. I'll just have to get used my other hard drives being sdb . . ..
Thanks guys.  The copy takes right at 3m30s now.
I made a change to dd years ago to make it default to 1 meg block size and to show
me the "Megs copied" on screen, so I can watch how fast dd is going.  With the 
older atapi drivers, this copy would be fast, but jerky and halting. With kernel
2.6.29 and after the halts were more frequent and longer, dragging the copy out
to over 9 minutes in this case.  With only the libata enabled, the "megs copied"
is very smooth, with no halting, though still right at 3m30s.
If you need me to test anything for the sake of the older drivers, I can.
Thanks again for the help.
