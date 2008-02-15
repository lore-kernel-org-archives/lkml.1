Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbYBOMBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbYBOMBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYBOMBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:01:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:54745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYBOMBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:01:17 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Handshaking on USB serial devices
To: Gene Heskett <gene.heskett@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Reply-To: 7eggert@gmx.de
Date: Fri, 15 Feb 2008 13:00:49 +0100
References: <9Wr5Z-7cw-1@gated-at.bofh.it> <9WSJ4-222-21@gated-at.bofh.it> <9WTlN-2T0-7@gated-at.bofh.it> <9WTYn-3Zb-29@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JPzFJ-00010v-IH@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19KqRugVKZrIuqc2Pwpiv7UsP3YrIWB4Q/u5f3
 EI8NHZZeYaWY2XQ+f/ObMyXFMtn42SlgYR4yNFiQoJiTPsoQWl
 /HR8eSe+w9fPjJwUFSlnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett <gene.heskett@gmail.com> wrote:

['cat /dev/hideaw0 | hexdump -v']

> Or some way to ship the 
> $00's to /dev/null so hexdump ignores them?

.. | perl -pe 's/\00//g/' | ...


