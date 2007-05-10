Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbXEJJwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbXEJJwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXEJJwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:52:00 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:57410 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754720AbXEJJv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:51:59 -0400
Message-Id: <46430780.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 
Date: Thu, 10 May 2007 11:52:32 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>, <discuss@x86-64.org>
Subject: pte_{ex,rd}protect
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Various architectures define these, but they aren't being used anywhere -
candidates for removal? The more that (at least) on i386 and x86-64
pte_exprotect() is not symmetrical to pte_exec() and pte_mkexec()...

Jan

