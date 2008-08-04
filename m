Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYHDM2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYHDM2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYHDM2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:28:25 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16305 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbYHDM2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:28:24 -0400
Message-Id: <48971232.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 04 Aug 2008 13:29:06 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, "Harvey Harrison" <harvey.harrison@gmail.com>,
       <tglx@linutronix.de>, "Roman Zippel" <zippel@linux-m68k.org>,
       "Nick Piggin" <npiggin@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: def_bool n
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could either of you clarify what the significance of such a construct
(encountered several times in arch/x86/Kconfig alone) is?

At first, I noticed it only with GENERIC_LOCKBREAK (it is my
understanding that this block can go away entirely), but then realized
that with the bool->def_bool conversion this was introduced in various
other places (where "default n" was used before, which seems as
pointless a statement). Am I missing something?

Thanks, Jan


