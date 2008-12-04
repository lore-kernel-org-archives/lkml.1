Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbYLDOu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbYLDOu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbYLDOuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:50:10 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:53986 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbYLDOuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:50:07 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [W1] extend userspace commands.
Date: Thu,  4 Dec 2008 17:50:04 +0300
Message-Id: <12284022104086-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi.

This patch series introduces and extends several userspace commands
used with netlink protocol.

Touch block command allows to write data and return sampled data to
the userspace.

Extended search and alarm seach commands to return list of slave
devices found during given search.

List masters command allows to send all registered master IDs to the
userspace.

Great thanks to Paul Alfille <paul.alfille@gmail.com> (owfs) who
tested this implementation and wrote w1-to-network daemon
http://sourceforge.net/projects/w1repeater/

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
