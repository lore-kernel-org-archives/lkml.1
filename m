Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbZLCHFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbZLCHFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZLCHFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:05:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:43612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZLCHFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:05:33 -0500
Date: Wed, 2 Dec 2009 23:07:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: liu pf <kernelfans@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Should we use preempt_disable() in sleep_on_common()?
Message-ID: <20091202230746.611f7fc5@infradead.org>
In-Reply-To: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com>
References: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 14:49:14 +0800
liu pf <kernelfans@gmail.com> wrote:

> Hi:
> 
> I am puzzled with the following scenario. Could anyone enlighten me?


sleep_on family of APIs is very racy and just cannot be used correctly;
I'm not surprised that there's a preempt race in it, but trust me, it's
not the biggest race... never ever use these APIs!!!


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
