Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0BHUt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:49:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab0BHUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:49:57 -0500
Date: Mon, 8 Feb 2010 12:48:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Len Brown <lenb@kernel.org>, inux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [BUG?] recursive locking in acpi_bus_register_driver
Message-Id: <20100208124845.f652e951.akpm@linux-foundation.org>
In-Reply-To: <28c262361002042258v7a7b8e87y3e376eaeb152b608@mail.gmail.com>
References: <28c262361002042258v7a7b8e87y3e376eaeb152b608@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010 15:58:07 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Is this a known bug or my hardware is bad ?
> I use mmotm 2010-02-03-20-09.
> 
> I didn't have a problem in 2.6.32.
> Unfortunately I can't test it at next week.
> I hope this problem can be reproduced easily.
> 

It would be useful if you could work out whether this bug is only in
-mm, or is in linux-next or is in mainline, please.

Probably it's in linux-next, and it might be due to driver core changes
or acpi changes.

Either way, we should get this weeded out lest the offending code turns
up in 2.6.34-rc1.

