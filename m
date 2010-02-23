Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0BWOym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:54:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:56756 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab0BWOyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:54:41 -0500
From: Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: UIO support for >32-bit physical addresses on 32-bit platforms
Date: Tue, 23 Feb 2010 08:54:16 -0600
Message-Id: <A596AEB5-BAF0-4BF9-A9C0-44C50B9BCA34@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
To: hjk@linutronix.de, Greg Kroah-Hartman <gregkh@suse.de>
Mime-Version: 1.0 (Apple Message framework v1077)
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans, Greg,

We are looking at using UIO for some driver work and noticed it assumes the address for MMIO regions is an 'unsigned long'.  This is a problem for the platforms we have in which we support a 36-bit physical address in a 32-bit machine.

Should we just change addr/size in struct uio_mem to u64 always?  At first I was thinking phys_addr_t but realized the addr could be PHYS, LOGICAL, or VIRTUAL.

- k

