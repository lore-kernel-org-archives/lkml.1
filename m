Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbXJRUPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbXJRUPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbXJRUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:15:31 -0400
Received: from kanga.kvack.org ([66.96.29.28]:60751 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbXJRUPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:15:30 -0400
Date: Thu, 18 Oct 2007 16:15:31 -0400
From: Marcelo Tosatti <marcelo@kvack.org>
To: linux-kernel@vger.kernel.org
Cc: drepper@redhat.com, riel@redhat.com
Subject: OOM notifications
Message-ID: <20071018201531.GA5938@dmt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

AIX contains the SIGDANGER signal to notify applications to free up some
unused cached memory:

http://www.ussg.iu.edu/hypermail/linux/kernel/0007.0/0901.html

There have been a few discussions on implementing such an idea on Linux,
but nothing concrete has been achieved.

On the kernel side Rik suggested two notification points: "about to
swap" (for desktop scenarios) and "about to OOM" (for embedded-like
scenarios).

With that assumption in mind it would be necessary to either have two
special devices for notification, or somehow indicate both events
through the same file descriptor.

Comments are more than welcome.

