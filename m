Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYGVShz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYGVShz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYGVShp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:37:45 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4438 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbYGVShp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:37:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] make ivtv_claim_stream() static
Date: Tue, 22 Jul 2008 20:34:48 +0200
User-Agent: KMail/1.9.9
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ivtv-devel@ivtvdriver.org,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
References: <20080722172012.GL14846@cs181140183.pp.htv.fi>
In-Reply-To: <20080722172012.GL14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807222034.49140.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 19:20:12 Adrian Bunk wrote:
> ivtv_claim_stream() can now become static.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks,

	Hans

>
> ---
>
>  drivers/media/video/ivtv/ivtv-fileops.c |    2 +-
>  drivers/media/video/ivtv/ivtv-fileops.h |    5 -----
>  2 files changed, 1 insertion(+), 6 deletions(-)
>
> b37d68a97cbf9a53c753bb0d63a3b1e8380ea51c
> diff --git a/drivers/media/video/ivtv/ivtv-fileops.c
> b/drivers/media/video/ivtv/ivtv-fileops.c index 7ec5c99..304261e
> 100644
> --- a/drivers/media/video/ivtv/ivtv-fileops.c
> +++ b/drivers/media/video/ivtv/ivtv-fileops.c
> @@ -39,7 +39,7 @@
>     associated VBI streams are also automatically claimed.
>     Possible error returns: -EBUSY if someone else has claimed
>     the stream or 0 on success. */
> -int ivtv_claim_stream(struct ivtv_open_id *id, int type)
> +static int ivtv_claim_stream(struct ivtv_open_id *id, int type)
>  {
>  	struct ivtv *itv = id->itv;
>  	struct ivtv_stream *s = &itv->streams[type];
> diff --git a/drivers/media/video/ivtv/ivtv-fileops.h
> b/drivers/media/video/ivtv/ivtv-fileops.h index 2c8d518..df81e79
> 100644
> --- a/drivers/media/video/ivtv/ivtv-fileops.h
> +++ b/drivers/media/video/ivtv/ivtv-fileops.h
> @@ -38,11 +38,6 @@ void ivtv_unmute(struct ivtv *itv);
>
>  /* Utilities */
>
> -/* Try to claim a stream for the filehandle. Return 0 on success,
> -   -EBUSY if stream already claimed. Once a stream is claimed, it
> -   remains claimed until the associated filehandle is closed. */
> -int ivtv_claim_stream(struct ivtv_open_id *id, int type);
> -
>  /* Release a previously claimed stream. */
>  void ivtv_release_stream(struct ivtv_stream *s);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


