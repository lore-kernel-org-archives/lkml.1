Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbZJNCHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbZJNCHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761332AbZJNCHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:07:12 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40660 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761231AbZJNCHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:07:09 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=aRq4Ow10j4gA:10 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8
 a=W0vUJOdyAAAA:8 a=6Hhw-4AeoF6RKra1lM4A:9 a=Uq3VrzhYLQvyGs4K2T4A:7
 a=KZjrsIMKP00gJEozHXVr3Wl8iT0A:4 a=x8gzFH9gYPwA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: buffer io error on device sr0?
Date: Tue, 13 Oct 2009 20:06:16 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-git2; KDE/4.3.2; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>
References: <200910130343.32162.tfjellstrom@shaw.ca> <4AD51D3F.2030603@gmail.com>
In-Reply-To: <4AD51D3F.2030603@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910132006.16747.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue October 13 2009, Robert Hancock wrote:
> On 10/13/2009 03:43 AM, Thomas Fjellstrom wrote:
> > I'm not sure which version it started, but it seems at least
> > 2.6.32-rc3-git2 has issues with detecting blank DVDR disks.
> >
> > [220595.198654] cdrom: This disc doesn't have any tracks I recognize!
> > [220595.298488] sr 3:0:0:0: [sr0] Unhandled sense code
> > [220595.298492] sr 3:0:0:0: [sr0] Result: hostbyte=DID_OK
> > driverbyte=DRIVER_SENSE
> > [220595.298496] sr 3:0:0:0: [sr0] Sense Key : Blank Check [current]
> > [220595.298501] sr 3:0:0:0: [sr0] Add. Sense: No additional sense
> > information [220595.298505] sr 3:0:0:0: [sr0] CDB: Read(10): 28 00 00 00
> > 00 00 00 00 01 00 [220595.298514] end_request: I/O error, dev sr0, sector
> > 0
> > [220595.298518] Buffer I/O error on device sr0, logical block 0
> > [220595.304554] sr 3:0:0:0: [sr0] Unhandled sense code
> > [220595.304562] sr 3:0:0:0: [sr0] Result: hostbyte=DID_OK
> > driverbyte=DRIVER_SENSE
> > [220595.304570] sr 3:0:0:0: [sr0] Sense Key : Blank Check [current]
> > [220595.304579] sr 3:0:0:0: [sr0] Add. Sense: No additional sense
> > information [220595.304588] sr 3:0:0:0: [sr0] CDB: Read(10): 28 00 00 00
> > 00 00 00 00 01 00 [220595.304609] end_request: I/O error, dev sr0, sector
> > 0
> > [220595.304616] Buffer I/O error on device sr0, logical block 0
> >
> > Unless its supposed to be this way. Although I didn't receive any kind of
> > notification when inserting the disk, as I used to (could be a hal/kde
> > error, but the logs in dmesg seem to hint otherwise).
> 
> Something tried to read off the disk and the drive reported "no way,
> it's blank". That's all this indicates. Most likely HAL or something is
> doing the read..

Ah, I was reading it as "Someone is checking for a disk, lets return an error 
instead of just saying the disk is blank".

Thanks for the clarification.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
