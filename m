Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYKECsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYKECsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 21:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYKECsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 21:48:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:56085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYKECsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 21:48:25 -0500
Date: Tue, 4 Nov 2008 18:48:54 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH: __bprm_mm_init(): remove uneeded goto
Message-ID: <20081104184854.72044220@infradead.org>
In-Reply-To: <20081104114703.c950f078.akpm@linux-foundation.org>
References: <20081104140314.1b196764@doriath.conectiva>
	<20081104105707.39dc5e30.akpm@linux-foundation.org>
	<20081104171414.6c1a8b52@doriath.conectiva>
	<20081104114703.c950f078.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 11:47:03 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> We used to do this trick a *lot* in the kernel (back in the 2.2 days?)
> for this performance reason.  Nowdays gcc is a lot more complex and we
> hope that it can sometimes work these things out for itself and we
> hope that `unlikely' might cause the compiler to move the unlikely
> code out of line.  But I don't know how successful the compiler is at
> doing this, and it'll be dependent upon the gcc version, the wind
> direction, etc.
> 

as far as I know, gcc tends to consider NULL pointer checks as unlikely
by default.

(but we can always tell it so if we think we know better..)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
