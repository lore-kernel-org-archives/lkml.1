Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXIJOJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXIJOJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbXIJOJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:09:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39055 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXIJOJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:09:37 -0400
Date: Mon, 10 Sep 2007 16:09:21 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Dong_Wei@nj.cpsecure.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: dynamically use the irqbalance
Message-ID: <20070910160921.5f8e2d73@laptopd505.fenrus.org>
In-Reply-To: <46E4A51D.2050804@nj.cpsecure.com>
References: <46E4A51D.2050804@nj.cpsecure.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 09:59:57 +0800
Dong_Wei <Dong_Wei@nj.cpsecure.com> wrote:

> Hi, all.
>    I want to dynamically use irqbalance on X86 processor. My design
> is like the following:
>    1) if we boot kernel with "noirqbalance", then irqbalance is
> always disabled.
>    2) if we boot kernel without "noirqbalance", we can enable/disable 
> irqbalance in runtime.

Hi,

kernel level irqbalance is not the right thing though (afaik it's in
feature-deprecation-schedule); please consider using the userland
irqbalancer instead (www.irqbalance.org). That also makes it entirely
easy to do what you want; since it's a daemon, starting and stopping it
follows standard Linux practice.


Greetings,
    Arjan van de Ven
