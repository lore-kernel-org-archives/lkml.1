Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbYLPSIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbYLPSIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYLPSIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:08:36 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:37185 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbYLPSIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:08:35 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [w1] userspace commands extensions.
Date: Tue, 16 Dec 2008 21:07:58 +0300
Message-Id: <1229450882-745-1-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.6.3
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi.

This small patchset extendes existing commands with reset, master IO and
status messages. Reset is used to reset the bus for given master device,
master IO command allows to initiate IO against bus itself not selecting
slave device first, which can be used to probe the device for example.
And status messages carry command completion status back to the
userspace (namely very useful to get -ENODEV from when requested device
was not found).

Great thanks to Paul Alfille <paul.alfille@gmail.com> of OWFS for
testing and commands suggestions.

