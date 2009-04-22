Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZDVJZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZDVJZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZDVJZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:25:38 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58204 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754954AbZDVJZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:25:37 -0400
Date: Wed, 22 Apr 2009 11:25:33 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Tejun Heo <tj@kernel.org>
cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       Joerg Dorchain <joerg@dorchain.net>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Laurent Vivier <Laurent@lvivier.info>, unsik Kim <donari75@gmail.com>
Subject: Re: [PATCH 12/14] block: replace end_request() with
 [__]blk_end_request_cur()
In-Reply-To: <1240331881-28218-13-git-send-email-tj@kernel.org>
Message-ID: <alpine.LRH.2.00.0904221120460.21306@vixen.sonytel.be>
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-13-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Tejun Heo wrote:
> end_request() has been kept around for backward compatibility;
> however, it's about time for it to go away.
> 
> * There aren't too many users left.
> 
> * Its use of @updtodate is pretty confusing.
> 
> * In some cases, newer code ends up using mixture of end_request() and
>   [__]blk_end_request[_all](), which is way too confusing.
> 
> So, add [__]blk_end_request_cur() and replace end_request() with it.

>  drivers/block/ps3disk.c         |    6 ++--
>  drivers/block/z2ram.c           |    4 +-

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
