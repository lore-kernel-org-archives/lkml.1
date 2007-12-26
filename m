Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbXLZSkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbXLZSkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 13:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXLZSkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 13:40:24 -0500
Received: from hs-out-0708.google.com ([64.233.178.250]:21671 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750883AbXLZSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 13:40:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hdci0436tWkfzw5jsAHgbZfc2ZwtDw4bf0XDUV1cC7/U6XIMVARPtTo5mliUc1bCmHHMAvg0Mt6kSEZvm9LLbCUFZ5oKNb7vBL30Z9oBe3/f3dsYD103PB+CNzt6AHn8IUq8QXkXjctRf8R7ax6aEIYJqRlCtPty6/JhD51KQJo=
Message-ID: <d2a348dd0712261040w402d6390o1b4f2abd83959c86@mail.gmail.com>
Date: Wed, 26 Dec 2007 10:40:22 -0800
From: "raki john" <raki4652@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Order of Loading mmc driver modules.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am working with pxamci driver(2.6.22.1). I have made , core and host
as  separate modules.

what is the correct order of loading the modules

i am doing in this order first core (mmc_core.ko), then card(mmc_block.ko)
after that host driver ( pxamci.ko). Is this correct.

I do not know much about Linux device model.

i saw that pxamci.ko driver registers it self as platform_driver. When
does its probe function is called. Is it called immediately  after
platform_driver_register(&pxamci_driver) is called.

also in card driver (mmc_block.ko) in block.c  file i saw a probe
function(mmc_blk_probe). How does it is invoked .

Thanks in advance for your help.


--
Thanks
raki
