Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYLHReW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYLHReW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 12:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYLHReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 12:34:11 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:50211 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYLHReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 12:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=d1ioybHewRiemk/2ZFGUIHEoWqqfOtUXXLk+Y3UVnbEoXrWwthPClngpwvQOyNdH8B
         bPyC2MDf8Eb7/0kR1jiPa90+4YAwtG4POM8WTe7naqA+Xft99lQDUaMrYZ+c0xOKyODA
         kQk6rhGzZ3pR//PY3PavGkyCQ2EuvTqjQYoIY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 0/4] ide: remove ide-scsi remnants
Date: Mon, 8 Dec 2008 18:33:00 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1228670471-3435-1-git-send-email-petkovbb@gmail.com> <20081207184316.GA30260@gollum.tnic>
In-Reply-To: <20081207184316.GA30260@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812081833.00406.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2008, Borislav Petkov wrote:
> On Sun, Dec 07, 2008 at 06:21:07PM +0100, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here are the patches removing bits and pieces belonging to the late ide-scsi :).
> > 
> 
> here's the correct (and not reversed :)) diffstat though:
> 
>  drivers/ide/ide-atapi.c  |   97 +++++++++-------------------------------------
>  drivers/ide/ide-io.c     |    3 -
>  drivers/ide/ide-ioctls.c |    3 +-
>  drivers/ide/ide-probe.c  |    2 -
>  include/linux/ide.h      |   34 ++++++----------
>  5 files changed, 33 insertions(+), 106 deletions(-)

Thanks, applied (though you could have combined all patches into
single one -- it is one logical change after all).

Bart
