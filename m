Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZFRAeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZFRAeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZFRAeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:34:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZFRAeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:34:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=bLBjbVmh3vcTAVyV6uP+TIdud+aucawZi1hu5K4v4fMSns+ZC5ROorWO8YkJOsrzV
	ESOOMf6vlA+wKw642YVzg==
From: Brian Swetland <swetland@google.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Revised patch series for minimal HTC Dream support
Date: Wed, 17 Jun 2009 17:31:12 -0700
Message-Id: <1245285075-20022-1-git-send-email-swetland@google.com>
X-Mailer: git-send-email 1.6.2.4
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This incorporates feedback from lkml/lakml, and I think is in
pretty good shape now.

msm_serial.c
- Ryan Mallon
  - remove some likely/unlikely not in hot-path code, for clarity
  - UART_TO_MSM() -> to_msm_uart()
  - clean up static structure declarations
- Pavel Machek
  - SUPPORT_SYSRQ needed for console break handling
  - remove hrtimer.h, other unused headers
  - Kconfig cleanup
- Alan Cox
  - set_termios should propogate used settings
- Linus Walleij
  - use resource_size() when appropriate
  - dev_err instead of printk(KERN_ERR...
  - remove some chatty printks
  - use __exit, __exit_p()

board-dream.c
- Stefan Schmidt
  - remove smc resources
  - remove unused headers

ll debug support
- Pavel Machek
  - remove extraneous 1002 label


