Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbXE3PZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbXE3PZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXE3PZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:25:38 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10277 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbXE3PZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:25:37 -0400
Message-ID: <465D9739.8070209@openvz.org>
Date: Wed, 30 May 2007 19:24:41 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH 0/8] RSS controller based on process containers (v3)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds RSS accounting and control within a container.

Ported above Paul's containers V10 with fixes received from Balbir.

RSS container includes the per-container RSS accounting
and reclamation, and out-of-memory killer. The container
behaves like a standalone machine - when it runs out of
resources, it tries to reclaim some pages, and if it doesn't
succeed, kills some task which mm_struct belongs to the
container in question.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
