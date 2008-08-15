Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbYHORnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbYHORnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbYHORmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:42:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39330 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbYHORmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:42:54 -0400
Date: Fri, 15 Aug 2008 19:42:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: venki.pallipadi@intel.com, suresh.b.siddha@intel.com
Subject: Please pull ioremap fix
Message-ID: <20080815174249.GA22026@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ACPI exposed a off by one bug in the PAT/ioremap changes. Please
pull the fix from the ACPI tree. This fixes
http://bugzilla.kernel.org/show_bug.cgi?id=11346

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-2.6 ioremap

Andi Kleen (1):
      x86: Fix ioremap off by one BUG

 arch/x86/mm/ioremap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
