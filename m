Return-Path: <linux-kernel-owner+w=401wt.eu-S938194AbXGUO7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938194AbXGUO7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759894AbXGUO5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:57:51 -0400
Received: from il.qumranet.com ([82.166.9.18]:45570 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbXGUO5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:57:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Clean up smp_call_function_single() callers
Date: Sat, 21 Jul 2007 17:57:53 +0300
Message-Id: <11850298772540-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that smp_call_function_single() knows how to call a function on
the currently running cpu, there is no need to do the elaborate
get_cpu()/put_cpu() dance.
