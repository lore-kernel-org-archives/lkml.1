Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907Ab0ASVwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0ASVwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324Ab0ASVwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:52:44 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:62962 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0ASVwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:52:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bqKfLOgJzh/oAX9uvG7ZSSMBKVuOe42ol7v5Ev24wKdzxvmNxaHuS10XE4C3idf+dE
         sqety+mfYMoREJpNLjhqdcIVrUbhXc6KB99jTjG0595gB4+Kwy3AE+jDhMTKB6VTHJoK
         wLgHPB1o84J/nQXPh+yJMF8txa7Q+cCYRLYcY=
MIME-Version: 1.0
In-Reply-To: <1263937351.18117.69.camel@Joe-Laptop.home>
References: <20100119211759.GE3804@infomag.iguana.be> <1263937351.18117.69.camel@Joe-Laptop.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 19 Jan 2010 16:52:21 -0500
Message-ID: <8bd0f97a1001191352n4968bebep2342912c571595fa@mail.gmail.com>
Subject: Re: [RFC] [PATCH] watchdog_info separation and constify
To: Joe Perches <joe@perches.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian@openwrt.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 16:42, Joe Perches wrote:
> On Tue, 2010-01-19 at 22:17 +0100, Wim Van Sebroeck wrote:
>> -static struct watchdog_info at32_wdt_info = {
>> +static const struct watchdog_info at32_wdt_info = {
>
> It'd be good to use a consistent structure name:
>
> static const struct watchdog_info ident = {
>        etc...
> }

i'd agree (obviously i'm partial to the "xxx_wdt_info" form), but i'd
worry about this after the watchdog implementations are finally
unified ... might be less code needing standardization at that point
-mike
