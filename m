Return-Path: <linux-kernel-owner+w=401wt.eu-S1763034AbYFHKdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763034AbYFHKdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 06:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbYFHKdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 06:33:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYFHKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:33:03 -0400
Date: Sun, 8 Jun 2008 07:32:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] v4l: saa7134: fix multiple clients access (and
 oops)
Message-ID: <20080608073255.67b8233c@gaivota>
In-Reply-To: <20080608063104.GA5608@joi>
References: <20080607224835.GA25025@joi>
	<20080608063104.GA5608@joi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 08:31:07 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Sun, Jun 08, 2008 at 12:48:35AM +0200, Marcin Slusarz wrote:
> > (...)
> 
> This patch is stupid. Please ignore.

Patch ignored. Yet, it seemed ok to my eyes. We shouldn't stop/deallocate
resources if there is still someone using the module.

Cheers,
Mauro
