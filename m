Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYA0TfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYA0TfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYA0Tcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:9237 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbYA0Tc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=WV0+IMm7wczVCi8UxsmzoeFLh54T4GFfi0ev0HUB3Z6+ygC5PjZaVsksduGB+espUb1KdyaVubd+8UsaBmEq6/ERIjcQFmx2hCSAJk7Ycu33Fn38cgCyGoINy3ZOKb4K6SK7Yo8b1+EI07Ps1YyxI0OLAyJbbIIWJrIbjreCZKQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 25/32] ide-tape: simplify code branching in the interrupt handler
Date: Sun, 27 Jan 2008 20:42:11 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-20-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-20-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801272042.12112.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> ... by adding a new typedef function pointer idetape_io_buf in order to call
> the proper buffer i/o handler depending on the data direction.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |   54 +++++++++++++++++++++++++----------------------
>  1 files changed, 29 insertions(+), 25 deletions(-)

[...]

> +typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, uint);

'uint' -> 'unsigned int'

[...]

Otherwise this patch is fine but depends on other patches needing rework
(please move it near the beginning of the series).

Thanks,
Bart
