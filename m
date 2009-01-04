Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZADPnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZADPnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZADPnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:43:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:55695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZADPnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:43:03 -0500
Date: Sun, 4 Jan 2009 07:44:54 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "=?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker" <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, davej@redhat.com
Subject: Re: [PATCH] bootchart: improve output based on Dave Jones' feedback
Message-ID: <20090104074454.17c103f9@infradead.org>
In-Reply-To: <c62985530901040736g5d9c1f20y248d6e6c635bede3@mail.gmail.com>
References: <20090104071638.64be922a@infradead.org>
	<c62985530901040736g5d9c1f20y248d6e6c635bede3@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 16:36:18 +0100
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 
> BTW, it looks like the async initcall feature has not been merged
> upstream, even not in tip/master. Was it too
> risky, not enough tested or something?

Linus didn't quite like how it was done (to put it mildly).

I've redone it this weekend (and am now cleaning the code up for
posting later today hopefully)... 
Linus was right (as usual); the new way is much better both in terms
of code cleanness and in terms of faster boot.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
