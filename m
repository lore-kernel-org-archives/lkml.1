Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYFJKus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYFJKus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYFJKuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:50:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:40730 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYFJKui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:50:38 -0400
Message-Id: <484E78CA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 10 Jun 2008 11:51:22 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: sys32_sigsuspend()'s need for ptregs parameter
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia32entry.S has a PTREGSCALL entry for sys32_sigsuspend(), yet the
function doesn't have a struct pt_regs * parameter. What's setting up
that argument good for? Or is this just a leftover?

Same would apply to sys_rt_sigsuspend().

Thanks, Jan

