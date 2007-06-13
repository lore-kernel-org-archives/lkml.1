Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbXFMPGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbXFMPGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXFMPGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:06:25 -0400
Received: from host-66-43-248-10 ([67.55.143.10]:45485 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757736AbXFMPGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:06:24 -0400
Subject: [BUG] ipfilter configuration regression from 2.6.20.14 -> 2.6.21
From: Paul Albrecht <albrecht@rdi1.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Jun 2007 10:11:06 -0400
Message-Id: <1181743866.3948.0.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I'm trying to move from 2.6.13.2 to 2.6.21.x so I imported my old kernel
configuration and recompiled 2.6.21.

When I booted my system with the updated kernel I found I couldn't
connect to my network. The reason I couldn't connect to my network is
because my default gateway is unreachable because of my iptable ruleset.
Since my ruleset worked before 2.6.21 and there were no other changes to
my software/hardware I would consider this a regression.

I don't really care so much about whether this incompatibility is
considered a regression or not but am simply wondering how I can
configure 2.6.21 for equivalent ipfilter functionality of earlier
releases.


Paul Albrecht
