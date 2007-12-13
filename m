Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbXLMQ4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbXLMQ4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXLMQzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:55:54 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:2139
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152AbXLMQzx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:55:53 -0500
Message-Id: <4761725A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 16:56:42 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <James.Bottomley@HansenPartnership.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: __get_vm_area() with VM_IOREMAP
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

in a change over three years ago, you added implicit aligning to
__get_vm_area() for VM_IOREMAP requests. I wonder, though,
whether it was intentional to over-align requests of sizes that are
an exact power of two (and between PAGE_SIZE and
(1 << IOREMAP_MAX_ORDER)). I would think that the argument of
fls() should be (size - 1) rather than size.

Thanks, Jan

