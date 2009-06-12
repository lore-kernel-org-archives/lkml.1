Return-Path: <linux-kernel-owner+w=401wt.eu-S1765668AbZFLNdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765668AbZFLNdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763396AbZFLN0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:08 -0400
Received: from ozlabs.org ([203.10.76.45]:54991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763289AbZFLN0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:26:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] cpumask: arch_send_call_function_ipi_mask
Date: Fri, 12 Jun 2009 22:55:54 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122255.54985.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, the archs which haven't already implemented
arch_send_call_function_ipi_mask implement it, and #define it
so the core knows.

The final patch rips out the #defines once everyone is converted.

Cheers,
Rusty.
