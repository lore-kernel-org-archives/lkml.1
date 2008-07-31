Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYGaLDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYGaLDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYGaLDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:03:37 -0400
Received: from bay0-omc2-s4.bay0.hotmail.com ([65.54.246.140]:48815 "EHLO
	bay0-omc2-s4.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbYGaLDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:03:36 -0400
Message-ID: <BAY103-DAV4E7BCB71048E6845C793DB27C0@phx.gbl>
X-Originating-IP: [80.204.235.254]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Tim Bird" <tim.bird@am.sony.com>
Cc: "Alistair John Strachan" <alistair@devzero.co.uk>,
       <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
       "Grant Coady" <gcoady.lk@gmail.com>
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl> <200807291815.13907.alistair@devzero.co.uk> <BAY103-W38794846AA924235B38E47B2820@phx.gbl> <488FAFE3.4040001@am.sony.com> <ntcv845p7kpiob7iqf6d1m8buj116ug4nv@4ax.com> <4890CB06.9040106@am.sony.com>
Subject: Re: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console on slackware 12.1
Date: Thu, 31 Jul 2008 13:02:10 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 31 Jul 2008 11:03:35.0882 (UTC) FILETIME=[142732A0:01C8F2FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:

> diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
> index 14c0e91..8c8119f 100644
> --- a/include/linux/vt_kern.h
> +++ b/include/linux/vt_kern.h
> @@ -74,7 +74,7 @@ void con_protect_unimap(struct vc_data *vc, int
rdonly);
>  int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
>
>  #define vc_translate(vc, c) ((vc)->vc_translate[(c) | \
> - (vc)->vc_toggle_meta ? 0x80 : 0])
> + ((vc)->vc_toggle_meta ? 0x80 : 0)])
>  #else
>  #define con_set_trans_old(arg) (0)
>  #define con_get_trans_old(arg) (-EINVAL)

indeed this patch fix the problem.
Thanks a lot.


