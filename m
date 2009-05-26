Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbZEZLim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbZEZLim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZEZLif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:38:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52248 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753978AbZEZLif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:38:35 -0400
Date: Tue, 26 May 2009 12:39:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "kvm-devel" <kvm-devel@lists.sourceforge.net>,
       lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lguest: fix on Intel when KVM loaded (unhandled trap
 13)
Message-ID: <20090526123914.1823adae@lxorguk.ukuu.org.uk>
In-Reply-To: <200905262054.42566.rusty@rustcorp.com.au>
References: <200905262054.42566.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 20:54:41 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> When KVM is loaded, and hence VT set up, the vmcall instruction in an
> lguest guest causes a #GP, not #UD.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Shouldn't that be fixed in KVM ?

Alan
