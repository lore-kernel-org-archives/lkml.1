Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbZJMIuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbZJMIuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZJMIuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:50:03 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:2256 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZJMIuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:50:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19156.16146.326389.380625@pilspetsen.it.uu.se>
Date: Tue, 13 Oct 2009 10:49:22 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Using intptr_t and uintptr_t in Kernel
In-Reply-To: <f22d86810910130037x48cac5c1s8928a6ff49dda381@mail.gmail.com>
References: <f22d86810910130037x48cac5c1s8928a6ff49dda381@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . writes:
 > I know variants of this questions have been asked on this list before,
 > but I could not
 > find a thread where a conclusion was reached, most of the time
 > responses were { I don't care,
 > developer's choice, might be in future } and variations thereof. But
 > one thing was clear
 > that do not mix userspace and kernel space data types.
 > 
 > Currently, I am porting a user space application to kernel, this app
 > uses intptr_t data type.
 > 
 > A look at linux/types.h shows that,
 > 
 > typedef unsigned long           uintptr_t;
 > 
 > but intptr_t is not defined at all. Also, isn't above definition
 > incorrect?

No, it's correct because Linux requires sizeof(void*) == sizeof(long).

 > Since the whole idea
 > behind uintptr_t is to store pointer in a int sized variable,

uintptr_t will use _some_ integer type, not necessarily 'int'.

If ISO C said 'int' there would be no need for {,u}intptr_t.

 > are we
 > not assuming here that
 > 
 > sizeof(int) = sizeof(unsigned long ) on all archs?

No, see above.
