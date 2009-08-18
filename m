Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZHRWHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZHRWHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZHRWHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:07:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbZHRWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:07:23 -0400
Date: Tue, 18 Aug 2009 15:06:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: dbrownell@users.sourceforge.net, vlobanov@speakeasy.net,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] amd5536udc: fixed shared interrupt bug and warning oops
Message-Id: <20090818150628.033c5936.akpm@linux-foundation.org>
In-Reply-To: <1250028056.14854.18.camel@pc>
References: <1250028056.14854.18.camel@pc>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 00:00:56 +0200
Thomas Dahlmann <dahlmann.thomas@arcor.de> wrote:

> Subject: [PATCH] amd5536udc: fixed shared interrupt bug and warning oops
>   - fixed shared interrupt bug reported by Vadim Lobanov
>   - fixed possible warning oops on driver unload when connected
>   - prevent interrupt flood in PIO mode ("modprobe amd5536udc use_dma=0")
>     when using gadget ether
>   - applied patch "Drop NULL test on list_entry result" submitted by Julia Lawall


Julia's patch is already in linux-next, so I can't apply this.
