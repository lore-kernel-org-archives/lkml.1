Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbXLJJhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbXLJJhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXLJJhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:37:11 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:37402 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXLJJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:37:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=J7DQufgwOlWOGkxRneCzyAIUbZEUxjQfgRQgqeUgEwJTeHgHzwHwaJ4aRJfg3487zSCjaWhPwdETxWXW5ijZJ+/W6xE+OLrGyPP4oZVJIV8x4YcpRlmS5JrG+Dj4hcOOVEpRfmP54Uki6UYlK1oQ+4X6jHhAhENu892jhQJkoag=
Message-ID: <f17812d70712100137h3aa0056bq78b0efb92d072891@mail.gmail.com>
Date: Mon, 10 Dec 2007 17:37:05 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       i2c@lm-sensors.org
Subject: [PATCH 0/2] gpiolib: add support for PCA9539
Cc: "David Brownell" <david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for PCA9539 as a GPIO chip is separated into two patches:

0001 - gpiolib: basic support for 16-bit PCA9539 GPIO expander
0002 - gpiolib: add Generic IRQ support for 16-bit PCA9539 GPIO expander

the 2nd one uses workqueue for IRQ handling due to the interrupt mode
nature of the i2c-core, thus making it a separate patch.

-- 
Cheers
- eric
