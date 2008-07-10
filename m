Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbYGJTF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbYGJTF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbYGJTFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:05:11 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:10465 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYGJTFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ITuxY0iyApubHvALZ4RuhuSz11rq1GCuO/dPy8Zy/SFjPwmHsNMGWwox4zKtD+YBND
         OXn9g/A0ES5mwuDLn957lmnwKws/XB8FI1kiv1sgRGuLhmkH5pLSc0IjZa43YT5xl6h5
         vJlYnPHWDI72Hly+6Gk76HyrYO6tqJ2LymFOs=
Subject: [PATCH 0/2] TI bq24022 regulator and virtual consumer current
	limit support
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 21:04:34 +0200
Message-Id: <1215716674.17490.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd be happy if the following two patches could be reviewed and
considered for inclusion into the voltage regulator framework git tree.

[PATCH 1/2] regulator: TI bq24022 Li-Ion Charger driver
[PATCH 2/2] regulator: virtual consumer current limit support

The bq24022 regulator is found on magician and blueangel among others
and can be used to control VBUS current draw from the gpio_vbus
(controlled by USB gadget) or pda_power (when connected to the wall
charger) drivers.

regards
Philipp

