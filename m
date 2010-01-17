Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023Ab0AQOyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0AQOyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963Ab0AQOyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:54:06 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47973 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab0AQOyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:54:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=voPv0dtW/dqXl/AHmTNpEfSzm4EXa6v0ahRRiPGblY99QEnBaV2RpCn5jXmhR71QZa
         4RufU5r7tQ5f8g7Vyagqp8og18MMJpqozNQ5AkSBD2guYw/BiYRuXytDUvLRaAZQky1C
         CmbDzpzlDah8ikD3xS4BBrooQ8dw3dQtc7fIM=
Message-ID: <4B5325A6.9000608@gmail.com>
Date: Sun, 17 Jan 2010 15:58:46 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Samuel Ortiz <samuel@sortiz.org>, irda-users@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: irda: two branches in via_ircc_change_dongle_speed() are the same
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in drivers/net/irda/via-ircc.c via_ircc_change_dongle_speed()

dongle_id case 0x0d:
two branches are the same whether `if (IsSIROn(iobase))' is true
or not. how should this be fixed?

Roel
