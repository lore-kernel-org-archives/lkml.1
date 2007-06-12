Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbXFLF1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbXFLF1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXFLF11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:27:27 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:33775 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbXFLF10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:27:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswMAAbLbUZKhRO4UGdsb2JhbACPPwEBGw0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: giel@caffeinetrip.com
Subject: Re: [PATCH] input: fix broken behaviour of Dell Latitude special keys
Date: Tue, 12 Jun 2007 01:27:24 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       Vojtech Pavlik <vojtech@suse.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Matt Domsch <matt_domsch@dell.com>,
       Rezwanul Kabir <rezwanul_kabir@dell.com>
References: <929318d30706101042q25418f9aif7c1a609fd792830@mail.gmail.com>
In-Reply-To: <929318d30706101042q25418f9aif7c1a609fd792830@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120127.25581.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 10 June 2007 13:42, Giel de Nijs wrote:
> Hi,
> 
> Following up on http://thread.gmane.org/gmane.linux.kernel.input/1375 here's
> a new patch to fix the fact that most Fn+F? special keys on (at least) the
> Dell Latitude laptops don't generate a key release event.

Thank you for the patch. Is there any way I could see data coming from i8042
when you press on these special keys? If you could do:

echo 1 > /sys/module/i8042/parameters/debug
tehn presses and released all these keys
echo 0 > /sys/module/i8042/parameters/debug

and send me dmesg I woudl appreciate that.

-- 
Dmitry
