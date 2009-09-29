Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbZI2Mwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbZI2Mwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZI2Mwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:52:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:35243 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbZI2Mwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:52:35 -0400
Date: Tue, 29 Sep 2009 14:53:00 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for
 memset/memcpy
Message-ID: <20090929145300.37402d14@infradead.org>
In-Reply-To: <200909291444.06422.arnd@arndb.de>
References: <20090928113433.5e9b8ea7@infradead.org>
	<200909291444.06422.arnd@arndb.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 14:44:06 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> > 
> 
> The patch looks good, but is there a reason to keep it architecture
> specific? I would guess that the same logic applies to all
> architectures with gcc-4.x and could be put into
> include/linux/compiler-gcc4.h.

there are some requirements on the architecture for this to work....
and as always with compiler things, the tradeoffs and how well it works
will vary per architecture.

If the architectures in large majority make this switch we could move it
generic... but it's a bit early for that.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
