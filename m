Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbZEANkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbZEANkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZEANkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:40:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48350 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751843AbZEANkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:40:05 -0400
Date: Fri, 1 May 2009 14:40:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
       linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Message-ID: <20090501144037.5a5dc65f@lxorguk.ukuu.org.uk>
In-Reply-To: <200905011520.34097.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
	<200905011453.32006.arnd@arndb.de>
	<20090501141414.4adfe4ab@lxorguk.ukuu.org.uk>
	<200905011520.34097.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In that case, I still think it would be good to have it in asm-generic.
> Half the architectures define it in this way currently, and new architectures
> would still have to think about it before falling back on the default.

Only if they noticed it was even present in the generic includes. Why
would they notice - meaningless code would just compile perfectly.
