Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbXFWHIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbXFWHIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXFWHIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:08:02 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:37781 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbXFWHIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:08:00 -0400
Date: Sat, 23 Jun 2007 09:06:55 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about fair schedulers
Message-ID: <20070623090655.36d1794c@localhost>
In-Reply-To: <200706230007.15622.info@gnebu.es>
References: <200706230007.15622.info@gnebu.es>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 00:07:15 +0200
Alberto Gonzalez <info@gnebu.es> wrote:

> My conclusion is that SD behaves as expected: it's more fair. But for a 
> desktop, shouldn't an "intelligently unfair" scheduler be better?

"intelligently unfair" is what the current scheduler is (because of
interactivity estimator).

When it works (say 90% of the time) the desktop feels really good...
but when it doesn't it can be a disaster.


Look this for example:

http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/6aa5c93c379ae9e1/98ab31c0e6fed2ee?&hl=en#98ab31c0e6fed2ee

-- 
	Paolo Ornati
	Linux 2.6.22-rc5-g0864a4e2 on x86_64
