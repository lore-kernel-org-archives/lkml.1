Return-Path: <linux-kernel-owner+w=401wt.eu-S1161023AbXDEDBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023AbXDEDBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXDEDBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:01:33 -0400
Received: from ozlabs.org ([203.10.76.45]:34845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbXDEDBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:01:32 -0400
Subject: Re: [PATCH] Lguest32 print hex on bad reads and writes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: virtualization@lists.osdl.org,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1175714071.9371.31.camel@localhost.localdomain>
References: <1175714071.9371.31.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 13:01:30 +1000
Message-Id: <1175742090.12230.630.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 15:14 -0400, Steven Rostedt wrote:
> Currently the lguest32 error messages from bad reads and writes prints a
> decimal integer for addresses. This is pretty annoying. So this patch
> changes those to be hex outputs.

(Erk, I wonder what I was thinking when I wrote that?)

Can I ask for %#x (or 0x%x)?  I'm easily confused.

Thanks!
Rusty.


