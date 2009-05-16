Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZEPAjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZEPAjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 20:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbZEPAjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 20:39:45 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:55216 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZEPAjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 20:39:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UuNShpY6o9Eox2jKk5YXl5Lr0qE0QbEDVOOyCchfF/m9hFx7d19bJRuhsQHRJ0r4De
         L+oKZPEENt6zUcWKlcp0xULjy/kzbWupOl2MmAmwAqfUckq3lPY8PmAS6Gm/IhwneSZf
         P2jkVyzueWQD32G4Pt60pqdYo820EtJlzlpMY=
MIME-Version: 1.0
In-Reply-To: <1242426182.10164.168.camel@falcon>
References: <1242426182.10164.168.camel@falcon>
Date: Fri, 15 May 2009 17:39:43 -0700
X-Google-Sender-Auth: 16a1414bae845d50
Message-ID: <1f1b08da0905151739v6bc2e5f6t57cb8e06cdda2673@mail.gmail.com>
Subject: Re: [PATCH 23/30] loongson: CS5536 MFGPT as system clock source 
	support
From: john stultz <johnstul@us.ibm.com>
To: wuzhangjin@gmail.com
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, zhangfx@lemote.com, yanh@lemote.com,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Erwan Lerale <erwan@thiscow.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 3:23 PM, Wu Zhangjin <wuzhangjin@gmail.com> wrote:
> +static struct clocksource clocksource_mfgpt = {
> +       .name = "mfgpt",
> +       .rating = 1200,

Minor nit. Please read the comment over the struct clocksource
definition in include/linux/clocksource.h for a guide to setting the
rating value for your clocksource.

thanks
-john
