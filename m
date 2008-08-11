Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYHKWfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYHKWfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYHKWfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:35:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:35791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYHKWfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:35:34 -0400
Date: Mon, 11 Aug 2008 15:35:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Subject: [patch 0/2] fastboot: allow skipping probing of known-unused ports
 in libata
Message-ID: <20080811153542.61095e5c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

if you KNOW a certain ata port is not connected (for example in a
netbook where there's just nothing there possible), we still probe
the port currently and waste time. This time is a significant part of
the total boot time.

This patch series introduces a module parameter that can be used
to tell the kernel which ports to skip, and the second patch
adds a DMI list for known setups so that for known cases
users don't have to add any parameters at all.

