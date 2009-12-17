Return-Path: <linux-kernel-owner+w=401wt.eu-S1764293AbZLQKEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764293AbZLQKEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764274AbZLQKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:04:12 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57050 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764247AbZLQKEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:04:10 -0500
Message-Id: <1261044246.6001.1350552807@webmail.messagingengine.com>
X-Sasl-Enc: YH41S/NdoRvwqj5QxKmCQXRTXLPJuOx/NNGeZmwZ7DEM 1261044246
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Lorne Applebaum" <lorne.applebaum@gmail.com>,
       "Matthew Garrett" <mjg@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20091217061725.GA26613@elte.hu>
References: <20091217061725.GA26613@elte.hu>
Subject: Re: -tip: origin tree build failure
Date: Thu, 17 Dec 2009 08:04:06 -0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you!

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

On Thu, 17 Dec 2009 07:17 +0100, "Ingo Molnar" <mingo@elte.hu> wrote:
> Today's -tip failed to build because commit 
> 0d204c34e85d1d63e5fdd3e3192747daf0ee7ec1 ("thinkpad-acpi: basic ALSA
> mixer 
> support (v2)") from today's upstream kernel causes the following build
> failure 
> on x86, for CONFIG_THINKPAD_ACPI=y && CONFIG_SOUND=m:
...

>  	depends on RFKILL || RFKILL = n
> +       depends on SOUND
>  	select BACKLIGHT_LCD_SUPPORT
>  	select BACKLIGHT_CLASS_DEVICE
>  	select HWMON

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

