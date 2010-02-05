Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab0BEUcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:32:07 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:43916 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753638Ab0BEUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:32:05 -0500
Date: Fri, 5 Feb 2010 23:32:01 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] OF GPIO integration for I2C/SPI GPIO chips
Message-ID: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here comes v2. Changes:

- In 'gpiolib: Introduce chip addition/removal notifier', open-coded
  gpio_call_chain().

- In 'of/gpio: Add support for two-stage registration for the
  of_gpio_chips', improved commit message.


David, I think it would be best if these patches could go via powerpc
or OF trees, so your Ack would be highly appreciated.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
