Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbYKRPM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbYKRPM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYKRPMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:12:46 -0500
Received: from kroah.org ([198.145.64.141]:50700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005AbYKRPMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:12:45 -0500
Date: Tue, 18 Nov 2008 07:09:03 -0800
From: Greg KH <greg@kroah.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, James.Bottomley@hansenpartnership.com, stable@kernel.org,
       lalit.chandivade@qlogic.com, linux-kernel@vger.kernel.org,
       andrew.vasquez@qlogic.com
Subject: Re: [stable] patch
	scsi-qla2xxx-correct-atmel-flash-part-handling.patch added to
	2.6.27-stable tree
Message-ID: <20081118150903.GA1281@kroah.com>
References: <20081117055003.2F349145446A@imap.suse.de> <200811180154.49395.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811180154.49395.s.L-H@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 01:54:44AM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Montag, 17. November 2008, gregkh@suse.de wrote:
> > 
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >      Subject: SCSI: qla2xxx: Correct Atmel flash-part handling.
> > 
> > to the 2.6.27-stable tree.  Its filename is
> > 
> >      scsi-qla2xxx-correct-atmel-flash-part-handling.patch
> 
> This unfortunately breaks the build.
> 
> drivers/scsi/qla2xxx/qla_sup.c: In function 'qla2xxx_get_flash_info':
> drivers/scsi/qla2xxx/qla_sup.c:628: error: 'scsi_qla_host_t' has no member named 'fdt_odd_index'
> make[6]: *** [drivers/scsi/qla2xxx/qla_sup.o] Error 1
> make[5]: *** [drivers/scsi/qla2xxx] Error 2
> make[4]: *** [drivers/scsi] Error 2

Crap :(

Lalit, can you fix this up?  I'm at a conference for the next two days
and probably will not have email access, nor time to try to resolve
this...

thanks,

greg k-h
