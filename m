Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbYKRPUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbYKRPUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYKRPUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:20:25 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:53831 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYKRPUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:20:25 -0500
Message-Id: <6F2B69F5-7312-49AB-B86A-6AE6B753095B@freescale.com>
From: Kumar Gala <kumar.gala@freescale.com>
To: linux-kernel Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: questions on how x86 uses IPI for tlb invalidates
Date: Tue, 18 Nov 2008 09:20:10 -0600
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at adding some code into powerpc for doing tlb invalidate  
broadcasts via IPI and am looking at the x86 code as a model.  I was  
wondering how the x86 code ensures we aren't interrupted in the  
process of doing something like flush_tlb_page().

- k
