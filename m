Return-Path: <linux-kernel-owner+w=401wt.eu-S2992472AbXCWPsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992472AbXCWPsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992466AbXCWPsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:48:13 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:42654 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992475AbXCWPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:48:12 -0400
From: Marcel Siegert <mws@linuxtv.org>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] DVB: Delete unused header file linux/dvb/version.h.
Date: Fri, 23 Mar 2007 16:47:53 +0100
User-Agent: KMail/1.9.6
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703231647.53780.mws@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2007, Robert P. J. Day wrote:
> 
> Delete the unreferenced header file include/linux/dvb/version.h.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
NACK
this header is unreferenced in kernel, but used for applications that compile for userspace
to determine the api version.

regards 
marcel

> ---
> 
> diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
> deleted file mode 100644
> index 6183c9c..0000000
> --- a/include/linux/dvb/version.h
> +++ /dev/null
> @@ -1,29 +0,0 @@
> -/*
> - * version.h
> - *
> - * Copyright (C) 2000 Holger Waechtler <holger@convergence.de>
> - *                    for convergence integrated media GmbH
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU Lesser General Public License
> - * as published by the Free Software Foundation; either version 2.1
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU Lesser General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
> - */
> -
> -#ifndef _DVBVERSION_H_
> -#define _DVBVERSION_H_
> -
> -#define DVB_API_VERSION 3
> -#define DVB_API_VERSION_MINOR 1
> -
> -#endif /*_DVBVERSION_H_*/


