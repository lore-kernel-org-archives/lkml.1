Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYKPW2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYKPW2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYKPW1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:27:54 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:38538 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbYKPW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:27:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pZbtZ/waEBP41s5JraB8RNeMTrZtow476YzAS+ZUjRpQ6dbUIevVZ758RaLj4VRz/O
         Z2V22C6ozaDDgZiyqJSoQxATY7y35B7eSBSlbtmZYsaA/uY4W20cEmlZ312CedFrutit
         +GTbkZLFqJ+X3JAvPhZPihwWhHkN14y9QQ8bQ=
Message-ID: <a278970e0811161427r2f941e10jafbc8ab1d425d64e@mail.gmail.com>
Date: Sun, 16 Nov 2008 23:27:51 +0100
From: "Luca Tiburzio" <luca.tiburzio@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PHYLIB dependency in kernel 2.6.27.6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to all,
in make process of linux 2.6.27.6 the PHYLIB depends on

NETDEVICES && !S390 && NET_ETHERNET

but if I enable only

Ethernet (1000 Mbit) (NETDEV_1000)
i loose visibility of PHYLIB

it should be better that  PHYLIB depends on:
NETDEVICES && !S390 && (NET_ETHERNET || NETDEV_1000)

Have a nice day.
Luca
