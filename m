Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbZL0VDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbZL0VDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbZL0VDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:03:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43500 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZL0VDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:03:15 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200912271003.631128760@firstfloor.org>
To: stefani@seibold.net, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [0/6] kfifo fixes/improvements
Date: Sun, 27 Dec 2009 22:03:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While porting some of my code to kfifo I found some issues, which
are addressed in the following patch series.

Some of the problems were serious, particularly the non atomic kfifo_in()
problem. That's probably 2.6.33 material at least. 

-Andi
