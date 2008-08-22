Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYHVOfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYHVOfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYHVOfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:35:45 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:31985 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYHVOfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:35:44 -0400
Message-Id: <48AEEB1E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 22 Aug 2008 15:36:46 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       <travis@sgi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: CONFIG_NR_CPUS limit for 32-bit
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that the fixmap area size depends on NR_CPUS and that it can't
possibly cover 4096 CPUs (its size would be beyond 200Mb if I put things
together correctly, whereas the vmalloc area [of which the fixmap area is
a sub-portion] by default is 128MB) I can't see how this new limit ought to
even boot on any system.

Therefore I wonder whether the range shouldn't be restricted for X86_32.

Jan

