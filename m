Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXBADFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXBADFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 22:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933383AbXBADFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 22:05:53 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:36487 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbXBADFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 22:05:53 -0500
Subject: mconf not removed by make mrproper
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 14:05:49 +1100
Message-Id: <1170299149.32500.13.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

The scripts/kconfig/mconf target isn't removed by the make mrproper
target. I can see a couple of possibilities, but wasn't sure which you'd
prefer, so thought I'd just raise the issue.

It's only an issue for me because my patch generation script relies on
make mrproper making a properly clean tree.

Regards,

Nigel

