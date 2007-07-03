Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbXGCGCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbXGCGCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXGCGCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:02:33 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:35569 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbXGCGCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:02:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] NIKON D50 problem
Date: Tue, 3 Jul 2007 08:02:30 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, "Ni@m" <niam.niam@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <a9e22dff0707021217r239ebcf0g8154a6e985b078f3@mail.gmail.com> <20070702155912.fe1e6834.akpm@linux-foundation.org>
In-Reply-To: <20070702155912.fe1e6834.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707030802.30516.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Andrew Morton:
> > Some time ago(I really can't remember version of the kernel)
> > everything was Ok. I'll try to find out the workable version of the
> > kernel ... but I've already tried 2.6.20 - the same =(.
> > I'm not sure, but It's possible that I've had ATA subsystem but not
> > libata ... I haven't tested this case yet.
> > 
> > PS. I can see photos on my camera ... flash card is Ok. I have this
> > problem even if I changed the flash card in this camera.
> 
> It's more likely a usb-storage or scsi layer problem.
> 
> The device reports as having 1984001 sectors and the kernel is reporting IO
> errors around the very end of the device.  Presumably an IO is straddling
> end-of-device and we're not handling that correctly.

Now I remember. We recently had a report about a buggy device, that close
to the end of the medium could handle only requests for single sectors.
I'll look into the archive.

	Regards
		Oliver

