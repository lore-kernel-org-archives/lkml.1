Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYL0AeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYL0AeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 19:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYL0AeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 19:34:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbYL0AeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 19:34:08 -0500
Date: Fri, 26 Dec 2008 16:34:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Patrizio Bassi" <patrizio.bassi@gmail.com>
Cc: "Kernel," <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [BUG] Kernel Panic with ath5k and 2.6.28
Message-Id: <20081226163404.c619fa4f.akpm@linux-foundation.org>
In-Reply-To: <742b1fb30812251218k66a090f6je8c1e0f9d98dffc5@mail.gmail.com>
References: <742b1fb30812251218k66a090f6je8c1e0f9d98dffc5@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-wireless)

On Thu, 25 Dec 2008 21:18:42 +0100 "Patrizio Bassi" <patrizio.bassi@gmail.com> wrote:

> Kernel Panic with ath5k and 2.6.28
> 
> Hi all,
> 
> Today i migrated to 2.6.28 and ath5k from 2.6.27 and madwifi.
> I have a trust speedshare turbo 108mb/s card
> Connection is ok, even with WPA.
> 
> The problem i met is when i tried to bridge the wifi and the eth interface.
> 
> I just rebuild the kernel with the bridge module enabled (builtin) and
> i got the panic
> in the picture (http://www.patriziobassi.it/downloads/ath5k_panic.jpg)

That trace doesn't have symbolic information hence it isn't a lot of
use.  Please set CONFIG_KALLSYMS=y and generate a new one.

> when i try to put the wifi interface up on startup with old script configuration
> 
> The strange thing is that i'm not adding it to the bridge, i just have
> it in the kernel and i'm enabling the interface.
> Eth interface goes up flawlessy.
> Workaround is to boot the laptop without the card plugged it (pcmcia)
> or do not compile the bridge into the kernel.
> 
> Attaching the working config. the broken just has the bridge module enabled.
> 
> I'm ready to test all the patches/suggestions you may provide.
> 
> Config is at http://www.patriziobassi.it/downloads/config-2.6.28
> 

