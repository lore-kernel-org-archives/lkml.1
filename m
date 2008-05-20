Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbYETUGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbYETUGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbYETUGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:06:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37998 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYETUGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:06:39 -0400
Date: Tue, 20 May 2008 13:06:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-ID: <20080520130624.089ebf19@infradead.org>
In-Reply-To: <483318AE.2090306@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
	<20080520152843.CF4181B4205@basil.firstfloor.org>
	<20080520085830.22c99115@infradead.org>
	<483318AE.2090306@firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 20:30:06 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven wrote:
> > On Tue, 20 May 2008 17:28:43 +0200 (CEST)
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> >> Add a new fops entry point to allow fasync without BKL. 
> > 
> > I (again) really don't like having another entry point for this...
> > it'll stay around forever rather than doing this as one step and 
> > move on.
> 
> Yes the goal is for it staying around forever, correct. And ->fasync()
> will go instead.
> 
> Advantage is that out of tree drivers will be compile broken which I
> consider an advantage. Yes I know Linus said earlier that's not
> important to him, but in this case my standards are higher than his.

I'd say it's just different standards.
My concern is that the new API as long lived is ugly and not the right
thing. I assume Linus and others have similar concerns, and weigh that
over the "some obscure out of tree driver might break".
