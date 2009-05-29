Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZE2M4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZE2M4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbZE2M4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:56:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41337 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754821AbZE2M4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:56:39 -0400
Date: Fri, 29 May 2009 13:57:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Iliya <vnsavage@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: per user memory limit and LSM module
Message-ID: <20090529135749.3531240f@lxorguk.ukuu.org.uk>
In-Reply-To: <b0b0b0000905290551t7e0a081bm814de19a8101814a@mail.gmail.com>
References: <b0b0b0000905290551t7e0a081bm814de19a8101814a@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any suggestions on how can I quickly get or maintain a list of all the
> running tasks per user(or just the memory usage), without patching the
> kernel would be greatly appreciated.

Even if you could what would you do with it, large parts of memory don't
have a single owner and even if they did you would have to traverse tens
of thousands of objects so it would be incredibly slow.

Take a look at the containers work and OpenVZ as I suspect that is what
you need to work from.
