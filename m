Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520Ab0AFGKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0AFGKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 01:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641Ab0AFGKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 01:10:44 -0500
Received: from ozlabs.org ([203.10.76.45]:32963 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab0AFGKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 01:10:43 -0500
Message-Id: <20100106045509.245662398@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jan 2010 15:55:09 +1100
From: Anton Blanchard <anton@samba.org>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/6] cpumask_of_node() should handle -1 as a node
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of places in the kernel use cpumask_of_node(-1), but most arch
NUMA implementations are broken. The following patches fix this.

Apologies for the resend, somehow quilt mail screwed up the message ids.

-- 

