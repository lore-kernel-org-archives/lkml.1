Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbYFFO7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbYFFO7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbYFFO7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:59:34 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:4420 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbYFFO7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:59:34 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <484950D2.9070809@tremplin-utc.net>
Date: Fri, 06 Jun 2008 16:59:30 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, pavel@ucw.cz,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
 ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080606102636.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080606102636.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi,
Hello,
> 
> 
> I would recommend converting the input piece to input_polled_device
> instead of managing the polling thread by yourselves.
Yes, you are right, I had forgotten about this one! That said, for now 
I'm working on removing the polling and relying only the interrupts. So 
if it works that shouldn't be needed :-)

See you,
Eric

