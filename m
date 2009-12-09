Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZLILA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZLILA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZLILAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:00:24 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37650 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZLILAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:00:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=spsgyYR8TiNOYPLc7X67OJiDF6MS66XiBmJJzfnm+TtBTWm5WkdVJ5Tor2P/3Pm4Tc
         KjXhr7/h/yv1AaGDACbyW4qlAvH5PTe0U3yh+b6wVUinJ+XRn60Pwwxuhbl2AfmZTsit
         cxABb/5rqnlMfA08rXEQqw36pzhaDOm8yxPqQ=
Subject: Re: [PATCH v9 5/8] Loongson: YeeLoong: add hardware monitoring
 driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20091208150229.GA1375@ucw.cz>
References: <cover.1260281599.git.wuzhangjin@gmail.com>
	 <5e9acb4cd757075f617daa45cbd6f5fad94678ac.1260281599.git.wuzhangjin@gmail.com>
	 <20091208150229.GA1375@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 09 Dec 2009 18:59:52 +0800
Message-ID: <1260356392.3926.2.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 16:02 +0100, Pavel Machek wrote:
> Hi!
> 
> > This patch adds hardware monitoring driver, it provides standard
> > interface(/sys/class/hwmon/) for lm-sensors/sensors-applet to monitor
> > the temperatures of CPU and battery, the PWM of fan, the current,
> > voltage of battery.
> 
> It is probably ok for now, but in future current/voltage of battery
> should be exported as power_supply class (drivers/power)...

Currently, the version based on the power_supply class have some
problems when using with gnome-power-manager(the whole system will hang
there), but works well with kpowersave, after fixing the bug, we will
use it instead of this APM Emulated one.

Thanks & Regards!
	Wu Zhangjin

