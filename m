Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0CBS2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:28:55 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38713 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752249Ab0CBS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:28:53 -0500
Date: Tue, 2 Mar 2010 21:28:50 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/12] ahci: Add support for non-PCI devices
Message-ID: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set refactors AHCI code to make it more generic, plus
adds a new platform driver to support AHCI interfaces integrated
into System-On-Chip devices.

The patches should apply on top of v2.6.33 (soon will be rebased
on top of linux-next).

I don't have any PCI AHCI handy (yet, but I plan to find one), so
PCI AHCI was only compile-tested.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
