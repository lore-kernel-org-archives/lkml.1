Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYFVRqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYFVRqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYFVRqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:46:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYFVRqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:46:02 -0400
Date: Sun, 22 Jun 2008 14:45:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix open/close race in saa7134
Message-ID: <20080622144549.29f230fe@gaivota>
In-Reply-To: <20080622172826.GA7487@joi>
References: <20080622100507.779acc59@infradead.org>
	<20080622172826.GA7487@joi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin,

> Simplier fix:
> http://lkml.org/lkml/2008/6/9/308
> But I don't remember whether it was applied or not...

I've applied your patch at my -git. I'll probably send later today to upstream.

Anyway, it seems valuable to use the same mutex also here, so I'm committing
Arjan patch as well.

Cheers,
Mauro
