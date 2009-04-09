Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZDIJ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZDIJ70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932394AbZDIJ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:58:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41034 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932376AbZDIJ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:58:39 -0400
X-Sasl-enc: TdkbwGn0xryvjuwkNosvUMyssMRSU52sQZBPQpEELLAs 1239271118
Message-ID: <49DDC6CB.50607@fastmail.fm>
Date: Thu, 09 Apr 2009 10:58:35 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org, isdn@linux-pingi.de
Subject: Re: [PATCH 18/56] isdn: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080437g55286754kd13b16ccc5139cb@mail.gmail.com> <49DCAC3D.5000600@fastmail.fm>
In-Reply-To: <49DCAC3D.5000600@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Respinned patch
>
> Thanks,
>
> Jack
>
> --
>
> isdn: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  drivers/isdn/hardware/eicon/capifunc.c  |    2 +-
>  drivers/isdn/hardware/eicon/diddfunc.c  |    2 +-
>  drivers/isdn/hardware/eicon/divasfunc.c |    2 +-
>  drivers/isdn/hardware/eicon/divasi.c    |   34
> +++++++++----------------------
>  drivers/isdn/hardware/eicon/idifunc.c   |    2 +-
>  drivers/isdn/hardware/eicon/mntfunc.c   |    2 +-
>  drivers/isdn/hardware/eicon/s_4bri.c    |    2 +-
>  drivers/isdn/hardware/eicon/um_idi.c    |    7 ++----
>  8 files changed, 18 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/isdn/hardware/eicon/capifunc.c
> b/drivers/isdn/hardware/eicon/capifunc.c
> index 4d425c6..7027547 100644
> --- a/drivers/isdn/hardware/eicon/capifunc.c
> +++ b/drivers/isdn/hardware/eicon/capifunc.c
> @@ -1072,7 +1072,7 @@ static int divacapi_connect_didd(void)
>              req.didd_notify.e.Req = 0;
>              req.didd_notify.e.Rc =
>                  IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
> -            req.didd_notify.info.callback = (void *)didd_callback;
> +            req.didd_notify.info.callback = didd_callback;
>              req.didd_notify.info.context = NULL;
>              DAdapter.request((ENTITY *) & req);
>              if (req.didd_notify.e.Rc != 0xff) {
> diff --git a/drivers/isdn/hardware/eicon/diddfunc.c
> b/drivers/isdn/hardware/eicon/diddfunc.c
> index 3029234..d97bfba 100644
> --- a/drivers/isdn/hardware/eicon/diddfunc.c
> +++ b/drivers/isdn/hardware/eicon/diddfunc.c
> @@ -63,7 +63,7 @@ static int DIVA_INIT_FUNCTION connect_didd(void)
>              req.didd_notify.e.Req = 0;
>              req.didd_notify.e.Rc =
>                  IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
> -            req.didd_notify.info.callback = (void *)didd_callback;
> +            req.didd_notify.info.callback = didd_callback;
>              req.didd_notify.info.context = NULL;
>              _DAdapter.request((ENTITY *) & req);
>              if (req.didd_notify.e.Rc != 0xff)
> diff --git a/drivers/isdn/hardware/eicon/divasfunc.c
> b/drivers/isdn/hardware/eicon/divasfunc.c
> index d36a4c0..2616a22 100644
> --- a/drivers/isdn/hardware/eicon/divasfunc.c
> +++ b/drivers/isdn/hardware/eicon/divasfunc.c
> @@ -170,7 +170,7 @@ static int DIVA_INIT_FUNCTION connect_didd(void)
>              req.didd_notify.e.Req = 0;
>              req.didd_notify.e.Rc =
>                  IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
> -            req.didd_notify.info.callback = (void *)didd_callback;
> +            req.didd_notify.info.callback = didd_callback;
>              req.didd_notify.info.context = NULL;
>              DAdapter.request((ENTITY *) & req);
>              if (req.didd_notify.e.Rc != 0xff) {
> diff --git a/drivers/isdn/hardware/eicon/divasi.c
> b/drivers/isdn/hardware/eicon/divasi.c
> index 69e71eb..2510886 100644
> --- a/drivers/isdn/hardware/eicon/divasi.c
> +++ b/drivers/isdn/hardware/eicon/divasi.c
> @@ -237,13 +237,10 @@ um_idi_read(struct file *file, char __user *buf,
> size_t count, loff_t * offset)
>          return (-ENODEV);
>      }
>  
> -    if (!
> -        (p_os =
> -         (diva_um_idi_os_context_t *) diva_um_id_get_os_context(file->
> -                                    private_data)))
> -    {
> +    if (!(p_os = diva_um_id_get_os_context(file-> private_data))) {
>          return (-ENODEV);
>      }
> +
>      if (p_os->aborted) {
>          return (-ENODEV);
>      }
> @@ -296,7 +293,7 @@ static int um_idi_open_adapter(struct file *file,
> int adapter_nr)
>      if (!(file->private_data = e)) {
>          return (0);
>      }
> -    p_os = (diva_um_idi_os_context_t *) diva_um_id_get_os_context(e);
> +    p_os = diva_um_id_get_os_context(e);
>      init_waitqueue_head(&p_os->read_wait);
>      init_waitqueue_head(&p_os->close_wait);
>      init_timer(&p_os->diva_timer_id);
> @@ -329,12 +326,10 @@ um_idi_write(struct file *file, const char __user
> *buf, size_t count,
>              return (-ENODEV);
>      }
>  
> -    if (!(p_os =
> -         (diva_um_idi_os_context_t *) diva_um_id_get_os_context(file->
> -                                    private_data)))
> -    {
> +    if (!(p_os = diva_um_id_get_os_context(file->private_data))) {
>          return (-ENODEV);
>      }
> +
>      if (p_os->aborted) {
>          return (-ENODEV);
>      }
> @@ -374,9 +369,7 @@ static unsigned int um_idi_poll(struct file *file,
> poll_table * wait)
>          return (POLLERR);
>      }
>  
> -    if ((!(p_os =
> -           (diva_um_idi_os_context_t *)
> -           diva_um_id_get_os_context(file->private_data)))
> +    if ((!(p_os = diva_um_id_get_os_context(file->private_data)))
>          || p_os->aborted) {
>          return (POLLERR);
>      }
> @@ -416,8 +409,7 @@ static int um_idi_release(struct inode *inode,
> struct file *file)
>          goto out;
>      }
>  
> -    if (!(p_os =
> -        (diva_um_idi_os_context_t *)
> diva_um_id_get_os_context(file->private_data))) {
> +    if (!(p_os = diva_um_id_get_os_context(file->private_data))) {
>          ret = -ENODEV;
>          goto out;
>      }
> @@ -484,9 +476,7 @@ static int remove_entity(void *entity)
>          return (0);
>      }
>  
> -    if (!(p_os =
> -         (diva_um_idi_os_context_t *)
> -         diva_um_id_get_os_context(entity))) {
> +    if (!(p_os = diva_um_id_get_os_context(entity))) {
>          DBG_FTL(("Zero entity os context on remove"))
>          return (0);
>      }
> @@ -557,9 +547,7 @@ void diva_um_idi_start_wdog(void *entity)
>      diva_um_idi_os_context_t *p_os;
>  
>      if (entity &&
> -        ((p_os =
> -          (diva_um_idi_os_context_t *)
> -          diva_um_id_get_os_context(entity)))) {
> +        ((p_os = diva_um_id_get_os_context(entity)))) {
>          mod_timer(&p_os->diva_timer_id, jiffies + 10 * HZ);
>      }
>  }
> @@ -569,9 +557,7 @@ void diva_um_idi_stop_wdog(void *entity)
>      diva_um_idi_os_context_t *p_os;
>  
>      if (entity &&
> -        ((p_os =
> -          (diva_um_idi_os_context_t *)
> -          diva_um_id_get_os_context(entity)))) {
> +        ((p_os = diva_um_id_get_os_context(entity)))) {
>          del_timer(&p_os->diva_timer_id);
>      }
>  }
> diff --git a/drivers/isdn/hardware/eicon/idifunc.c
> b/drivers/isdn/hardware/eicon/idifunc.c
> index db87d51..5399cc1 100644
> --- a/drivers/isdn/hardware/eicon/idifunc.c
> +++ b/drivers/isdn/hardware/eicon/idifunc.c
> @@ -197,7 +197,7 @@ static int DIVA_INIT_FUNCTION connect_didd(void)
>              req.didd_notify.e.Req = 0;
>              req.didd_notify.e.Rc =
>                  IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
> -            req.didd_notify.info.callback = (void *)didd_callback;
> +            req.didd_notify.info.callback = didd_callback;
>              req.didd_notify.info.context = NULL;
>              DAdapter.request((ENTITY *) & req);
>              if (req.didd_notify.e.Rc != 0xff) {
> diff --git a/drivers/isdn/hardware/eicon/mntfunc.c
> b/drivers/isdn/hardware/eicon/mntfunc.c
> index a564b75..2251662 100644
> --- a/drivers/isdn/hardware/eicon/mntfunc.c
> +++ b/drivers/isdn/hardware/eicon/mntfunc.c
> @@ -88,7 +88,7 @@ static int DIVA_INIT_FUNCTION connect_didd(void)
>              req.didd_notify.e.Req = 0;
>              req.didd_notify.e.Rc =
>                  IDI_SYNC_REQ_DIDD_REGISTER_ADAPTER_NOTIFY;
> -            req.didd_notify.info.callback = (void *)didd_callback;
> +            req.didd_notify.info.callback = didd_callback;
>              req.didd_notify.info.context = NULL;
>              DAdapter.request((ENTITY *) & req);
>              if (req.didd_notify.e.Rc != 0xff)
> diff --git a/drivers/isdn/hardware/eicon/s_4bri.c
> b/drivers/isdn/hardware/eicon/s_4bri.c
> index 25c5d7f..28e8410 100644
> --- a/drivers/isdn/hardware/eicon/s_4bri.c
> +++ b/drivers/isdn/hardware/eicon/s_4bri.c
> @@ -189,7 +189,7 @@ static byte * qBri_check_FPGAsrc (PISDN_ADAPTER
> IoAdapter, char *FileName,
>      char  *fpgaFile, *fpgaType, *fpgaDate, *fpgaTime ;
>      dword  fpgaFlen,  fpgaTlen,  fpgaDlen, cnt, year, i ;
>  
> -    if (!(File = (byte *)xdiLoadFile (FileName, Length, 0))) {
> +    if (!(File = xdiLoadFile (FileName, Length, 0))) {
>          return (NULL) ;
>      }
>  /*
> diff --git a/drivers/isdn/hardware/eicon/um_idi.c
> b/drivers/isdn/hardware/eicon/um_idi.c
> index 6563db9..55eb212 100644
> --- a/drivers/isdn/hardware/eicon/um_idi.c
> +++ b/drivers/isdn/hardware/eicon/um_idi.c
> @@ -679,9 +679,7 @@ static int process_idi_ind(divas_um_idi_entity_t *
> e, byte ind)
>      int do_wakeup = 0;
>  
>      if (e->e.complete != 0x02) {
> -        diva_um_idi_ind_hdr_t *pind =
> -            (diva_um_idi_ind_hdr_t *)
> -            diva_data_q_get_segment4write(&e->data);
> +        diva_um_idi_ind_hdr_t *pind =
> diva_data_q_get_segment4write(&e->data);
>          if (pind) {
>              e->e.RNum = 1;
>              e->e.R->P = (byte *) & pind[1];
> @@ -734,8 +732,7 @@ static int write_return_code(divas_um_idi_entity_t *
> e, byte rc)
>  {
>      diva_um_idi_ind_hdr_t *prc;
>  
> -    if (!(prc =
> -         (diva_um_idi_ind_hdr_t *) diva_data_q_get_segment4write(&e->rc)))
> +    if (!(prc = diva_data_q_get_segment4write(&e->rc)))
>      {
>          DBG_ERR(("A: A(%d) E(%08x) rc(%02x) lost",
>               e->adapter->adapter_nr, e, rc));
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

