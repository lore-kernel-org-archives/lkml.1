Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbYA3PrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbYA3PrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbYA3Pqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:46:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57366 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbYA3Pqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:46:48 -0500
Date: Wed, 30 Jan 2008 07:45:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: ioremap_xxx() with EXEC enabled
Message-ID: <20080130074540.031b6799@laptopd505.fenrus.org>
In-Reply-To: <1201685530.17912.11.camel@caritas-dev.intel.com>
References: <1201685530.17912.11.camel@caritas-dev.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 17:32:10 +0800
"Huang, Ying" <ying.huang@intel.com> wrote:

> Hi,
> 
> On i386, EFI may need to map EFI runtime code area as EXEC enabled
> with ioremap(). But, I found that the memory are mapped as EXEC
> disabled when mapped with ioremap() now. I think we may need a method
> to map memory area as EXEC enabled with ioremap_xxx(). Some possible
> interface schemes for mapping as EXEC enabled are as follow:
> 
> - Interface scheme 1:

scheme 3:

set_memory_x(... )
