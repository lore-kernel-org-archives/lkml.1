Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZERETS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZERETS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 00:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZERETA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 00:19:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:48733 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZERETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 00:19:00 -0400
Date: Sun, 17 May 2009 21:18:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090517211852.718059c5@infradead.org>
In-Reply-To: <d82e647a0905171855x79850a5bv7262f9e698d8b3f7@mail.gmail.com>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	<20090517132613.688da272@infradead.org>
	<d82e647a0905171855x79850a5bv7262f9e698d8b3f7@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 09:55:14 +0800
Ming Lei <tom.leiming@gmail.com> wrote:

> >
> > in cases where you don't want to fail while in the atomic portion,
> > but can fail better earlier.
> 
> If we do this way, the type of async_schedule*()  and
> async_schedule*_inatomic() is different, and callers will be messed
> with them, especially for _inatomic().

I'm not so much proposing the external "simple API" to have this,
but the primitive should have it, so that we can provide a
__async_schedule_inatomic() which does have the option..


> 
> BTW: I have submited new version of this patches, would you mind
> giving a review?

I gave comments on various threads from my inbox, but I cannot rule out
having missed one... If you think I missed one, could you send me a 
private email with the latest patches you want reviewed (even if it's a
forward from what you sent earlier)?

I'm happy to see these enhancements btw...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
