Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYGTWPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYGTWPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYGTWOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:14:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:38176 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYGTWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:14:47 -0400
Date: Sun, 20 Jul 2008 15:14:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Simon Arlott <simon@fire.lp0.eu>,
       Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: [patch 0/4] Second batch of fastboot patches: get rid of the 2
 second rootfs delay
Message-ID: <20080720151436.26bdc717@infradead.org>
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

this second batch of fastboot patches gets rid of the delay you can get
when you're not using an initrd; on my system this delay is a full 2
seconds (which is longer than the whole kernel boot combined).

I've also stuck the patch series into a git tree

clone git://git.kernel.org/pub/scm/linux/git/arjan/linux-2.6-fastboot

