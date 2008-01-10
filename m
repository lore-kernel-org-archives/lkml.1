Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYAJUnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYAJUnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYAJUnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:43:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48558 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbYAJUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:43:08 -0500
Date: Thu, 10 Jan 2008 20:40:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: speed setup failure reporting
Message-ID: <20080110204020.6c965d5a@lxorguk.ukuu.org.uk>
In-Reply-To: <20080109222352.c112b4eb.akpm@linux-foundation.org>
References: <20080103165507.3fe5b7a4@lxorguk.ukuu.org.uk>
	<20080109222352.c112b4eb.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It only causes a problem if you set a completely bogus baud rate (out of
range) and that baud rate was not a standard one and you were using the
new tty ioctls - so its fairly low priority 8)
