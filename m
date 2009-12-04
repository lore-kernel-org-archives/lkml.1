Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZLDO5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZLDO5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZLDO5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:57:23 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56625 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZLDO5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:57:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KHcsB1oqf6TG1swTmld3i6ApEtURPxP/3BHRU69x+5qQzIul16/tiriuQr017MbODn
         luIYtfQiGvgup9tblyjx6uONT2gwCm73dLhbEX6Aos9567phpxs12suQeJJz9V4MhpJT
         cWXyBOJAKFKcejdXNpgmIre64ohy0VuOexZuw=
Subject: Re: [PATCH v7 4/8] Loongson: YeeLoong: add battery driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-laptop@vger.kernel.org,
       Hongbing Hu <huhb@lemote.com>
In-Reply-To: <20091204080408.GA1540@ucw.cz>
References: <cover.1259932036.git.wuzhangjin@gmail.com>
	 <059fa216d70771a6341edb2db4cc559e958273e9.1259932036.git.wuzhangjin@gmail.com>
	 <20091204080408.GA1540@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 04 Dec 2009 22:56:54 +0800
Message-ID: <1259938614.9554.2.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 09:04 +0100, Pavel Machek wrote:
> On Fri 2009-12-04 21:34:17, Wu Zhangjin wrote:
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > This patch adds APM emulated Battery Driver, it provides standard
> > interface(/proc/apm) for user-space applications(e.g. kpowersave,
> > gnome-power-manager) to manage the battery.
> 
> It would be nicer if this went to drivers/power, and used its
> interface -- providing not only percentage but also other values.

There is a version basic on the power supply interface, but it is buggy.

Regards,
	Wu Zhangjin


