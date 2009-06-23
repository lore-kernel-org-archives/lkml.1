Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZFWONc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZFWONc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759957AbZFWONU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:13:20 -0400
Received: from mail.atmel.fr ([81.80.104.162]:49811 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760025AbZFWONT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:13:19 -0400
Message-ID: <4A40E2E6.9060904@atmel.com>
Date: Tue, 23 Jun 2009 16:12:54 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>, plagnioj@jcrosoft.com
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       avictor.za@gmail.com
Subject: Re: [RFC PATCH] atmel_lcdfb Kconfig: remove long dependency line
References: <4A40D695.5000302@atmel.com>	<1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com> <20090623153556.0e574899@hskinnemoen-d830>
In-Reply-To: <20090623153556.0e574899@hskinnemoen-d830>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen :
> Nicolas Ferre wrote:
>> +config ARCH_ATMEL_HAS_FB
>> +	bool
>> +	depends on FB
>> +	default n
> 
> What happens when we unconditionally select something which depends on
> something else?

:-P

Experience shows that this configuration is selected.

The dependency allows to have a good hierarchy in the configuration tree...
Better proposition welcome.

Bye,
-- 
Nicolas Ferre

