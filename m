Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbZLPRKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbZLPRKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762313AbZLPRGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:53823 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:30 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/12] sched: cleanup set_task_cpu() issues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot more invasive than I would have liked, but at least it seems to cover all
races I spotted.



