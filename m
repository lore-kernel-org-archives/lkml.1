Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbYAPLSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbYAPLSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYAPLSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:18:10 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:15483
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbYAPLSJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:18:09 -0500
Message-Id: <478DF61E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 16 Jan 2008 11:18:38 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, <david-b@pacbell.net>,
       <linux-kernel@vger.kernel.org>
Subject: non-choice related config entries within choice
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman,

now that I finally found time to look into the problems that caused the
patch changing boolean/tristate choice behavior to be reverted I find
that due to the way things worked in the past there are a couple of
cases where config options not really belonging to the choice are inside
the choice scope (drivers/usb/gadget/Kconfig, arch/ppc/Kconfig, and
arch/mips/Kconfig are where I found such cases, and I hope this is a
complete list).

The question is: Is it intended for this to work the way it used to, or
is it rather reasonable to change these scripts so that stuff dependent
upon the choice selection is being dealt with outside the choice scope?

Thanks, Jan

