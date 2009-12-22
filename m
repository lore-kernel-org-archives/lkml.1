Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZLVMoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZLVMoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZLVMoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:44:17 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:27391 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZLVMoR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Tue, 22 Dec 2009 07:44:17 -0500
Message-Id: <4B30CD2E02000078000272AA@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 22 Dec 2009 12:44:14 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Roman Zippel" <zippel@linux-m68k.org>, <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Kconfig choice oddities?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, Roman,

what is the reason for the difference in behavior between choices' and
simple options' prompts followed by conditionals? For simple options, the
conditional, if evaluating to false, just hides the prompt (forcing the
default to be used), but for choices it seems to eliminate the choice
altogether (i.e. it appears to have the same effect as a "depends on").

Further, is it really appropriate to write out the settings of all choice
members, even those that have dependencies evaluating to false? The
effect of this is that when the dependencies change, resulting in a new
choice member to become visible, "make oldconfig" doesn't present the
choice to the user since a "selected" value was already read from
.config.

Thanks, Jan

