Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZGMQSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZGMQSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbZGMQSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:18:12 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40600 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbZGMQSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=meXBcYiDH0xhcm2QguTrH3z7gcdkmxjRpBJ7OLqeJCVRymZWOTo6zQ1XllGr1jT03V
         m2XMHrMhPeQCwaUbZg6z9lVaTM+f5U0d/0+rHv3bFXJ2PKkTB4GNW3gMAU+ts/dgvUcL
         YH0zpDUYHmzYUIFx4Qa2MCyNUHC9LEVRVHnm0=
Message-ID: <4A5B5E40.2070700@gmail.com>
Date: Mon, 13 Jul 2009 18:18:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-bluetooth@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: bluetooth_cs: schedule in atomic?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

can (bt_cb(skb)->pkt_type & 0x80) test in bluecard_write_wakeup() be
true while called from interrupt (either directly or through
bluecard_receive()?

Thanks.
