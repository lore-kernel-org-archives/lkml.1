Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZLVWmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZLVWmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 17:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZLVWmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 17:42:38 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:52939 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZLVWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 17:42:37 -0500
Date: Tue, 22 Dec 2009 17:42:18 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] MFGPT: move clocksource menu
Message-ID: <20091222174218.33f842ea@mycelium.queued.net>
In-Reply-To: <4B312761.7080001@oracle.com>
References: <4B312761.7080001@oracle.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, fine w/ me.

Acked-by: Andres Salomon <dilinger@collabora.co.uk>


On Tue, 22 Dec 2009 12:09:05 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move the CS5535 MFGPT hrtimer kconfig option to be with the
> other MFGPT options.  This makes it easier to find and also
> removes it from the main "Device Drivers" menu, where it should
> not have been.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Andres Salomon <dilinger@collabora.co.uk>
> ---
>  drivers/Kconfig             |    2 --
>  drivers/clocksource/Kconfig |    9 ---------
>  drivers/misc/Kconfig        |    9 +++++++++
>  3 files changed, 9 insertions(+), 11 deletions(-)
