Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbXLaLMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbXLaLMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 06:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbXLaLL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 06:11:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXLaLL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 06:11:56 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Get physical MAC address
To: Theewara Vorakosit <thvo@hpcnc.cpe.ku.ac.th>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 31 Dec 2007 12:11:46 +0100
References: <9Gmk2-1M1-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1J9IYc-0000rr-QC@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+oKIu7/JEa6NQPMNXweGAcUfDmjeLRCBlLioH
 3mhz/UMUojJpekrXc1X1G3cMgKPo0tUxkLEgcqyAaXMzIOUdRv
 JubV7ycJOM8azoeoMIPeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theewara Vorakosit <thvo@hpcnc.cpe.ku.ac.th> wrote:

> I get MAC address from ioctl. However, ifconfig can change this  MAC
> address. Can I get a real physical MAC address of the NIC?

First, get a network card having a physical MAC. Most cards have only a
(currently configured) default MAC address, maybe you'll be lucky
with some old ISA cards ...

Then, don't worry about sb changing it, since these cards don't support that.

