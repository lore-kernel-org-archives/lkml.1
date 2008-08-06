Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbYHFFTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbYHFFTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYHFFTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:19:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59029
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbYHFFTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:19:17 -0400
Date: Tue, 05 Aug 2008 22:19:17 -0700 (PDT)
Message-Id: <20080805.221917.42858161.davem@davemloft.net>
To: jeff.chua.linux@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
From: David Miller <davem@davemloft.net>
In-Reply-To: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jeff Chua" <jeff.chua.linux@gmail.com>
Date: Wed, 6 Aug 2008 11:15:30 +0800

> I've a Dell R900 with 4 quad-core Xeon processors (total 16CPUs), but
> can only managed to boot up with CONFIG_NR_CPUS=8. Setting
> CONFIG_NR_CPUS=16 causes the kernel to hang while booting.
> 
> 
> Here's the dmesg with CONFIG_NR_CPUS=8 ...

Do you have lockdep enabled?  If sure, try turning that off.
