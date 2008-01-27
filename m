Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYA0TdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYA0TdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYA0TcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:17 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:32949 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbYA0TcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=S1kRCi8ElS2n+yI2ws4tncOv37L8XhgYfMiu1Gm01S8QDG3Qoi1+sd1QWK4HnqFnIJ+9VNFWCYUMQyc3r7uKH0mXkLTIVQ9g0fL0NgDVTVF7Ljoxb7Pt7yV7qivbWGy46jJGLDt5jxSVrxgoRJVYdYaSXVBTKBF5yPRM12t9km8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 06/32] ide-tape: remove IDETAPE_DEBUG_BUGS
Date: Sun, 27 Jan 2008 16:35:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801271635.17850.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied

> ---
>  drivers/ide/ide-tape.c |   42 ++----------------------------------------
>  1 files changed, 2 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index dbececc..efb9d25 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -107,7 +107,6 @@ typedef struct os_dat_s {
>   *	The following are used to debug the driver:
>   *
>   *	Setting IDETAPE_DEBUG_LOG to 1 will log driver flow control.
> - *	Setting IDETAPE_DEBUG_BUGS to 1 will enable self-sanity checks in
>   *	some places.

the above line should also go away (I removed it while merging the patch)
