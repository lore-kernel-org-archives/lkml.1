Return-Path: <linux-kernel-owner+w=401wt.eu-S1764563AbXJXQ56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764563AbXJXQ56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763613AbXJXQmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:42:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42228 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763608AbXJXQmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:42:05 -0400
Date: Wed, 24 Oct 2007 09:38:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 cpufreq.c:cpufreq_get()
Message-ID: <20071024093839.232e5cd5@laptopd505.fenrus.org>
In-Reply-To: <20071024162312.GH30533@stusta.de>
References: <20071024162312.GH30533@stusta.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 18:23:12 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> cpufreq.c:cpufreq_get() no longer has any user.
> 

it's... also a really bad/buggy interface... frquency is a per cpu
property for one, and constantly changing (esp in a multi-core world)
even depending on what other parts of the system are doing.
