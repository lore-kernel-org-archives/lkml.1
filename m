Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbZEALQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbZEALQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbZEALQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:16:43 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:57655 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbZEALQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:16:42 -0400
MIME-Version: 1.0
In-Reply-To: <20090430222900.c13b63d5.akpm@linux-foundation.org>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 13:16:22 +0200
Message-ID: <ac3eb2510905010416q36c9e155ya4131cf82dfd13bc@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 07:29, Andrew Morton <akpm@linux-foundation.org> wrote:

> dev->type->nodename() might have failed due to -ENOMEM, in which case
> it seems wrong to assume that it returned NULL for <whatever reason you
> thought it might want to return NULL>.
>
> It's all a bit confused.

This logic is only for providing a custom name hint. Only a few
devices need that at all. If the allocation fails, the default name
will be used, not the custom name.

Thanks,
Kay
