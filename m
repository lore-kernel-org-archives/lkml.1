Return-Path: <linux-kernel-owner+w=401wt.eu-S935387AbXJPSdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387AbXJPSdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933939AbXJPSc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:32:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56071 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbXJPScz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:32:55 -0400
Date: Tue, 16 Oct 2007 11:30:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: reduce frequency of cursor blinking
Message-ID: <20071016113037.2fa3cd6f@laptopd505.fenrus.org>
In-Reply-To: <20071016181911.GA24428@redhat.com>
References: <20071016181911.GA24428@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 14:19:11 -0400
Dave Jones <davej@redhat.com> wrote:

> Depending on CONFIG_HZ, we blink the cursor at 20,50,60 or 200Hz.

eh no, that's 5 times per second ...

> -	mod_timer(&ops->cursor_timer, jiffies + HZ/5);

