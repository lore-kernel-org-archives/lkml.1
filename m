Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYLUN5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYLUN5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 08:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYLUN5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 08:57:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33290 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbYLUN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 08:57:45 -0500
Subject: Re: [regression] uml is very slow on 2.6.28 host
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1LB4QO-0005fk-7g@pomaz-ex.szeredi.hu>
References: <E1LB4QO-0005fk-7g@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 21 Dec 2008 14:57:38 +0100
Message-Id: <1229867858.9487.238.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 10:35 +0100, Miklos Szeredi wrote:
> When the UML boot gets to the userspace part it gets really really
> slow.  It takes about 20 times the normal time to fully boot.  CPU
> seems to be idle.
> 
> Guest version doesn't matter.  Host version 2.6.27 was OK, latest git
> is not OK.  I'm running 32bit guest on 64bit host.

Does:

http://lkml.org/lkml/2008/12/16/40

help any?
