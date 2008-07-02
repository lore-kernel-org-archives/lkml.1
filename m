Return-Path: <linux-kernel-owner+w=401wt.eu-S932276AbYGBL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbYGBL6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYGBL60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:58:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59444 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYGBL6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:58:25 -0400
Date: Wed, 2 Jul 2008 07:54:59 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-arch@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
Subject: Re: [PATCH 16/23] make section names compatible with
 -ffunction-sections -fdata-sections: ppc
Message-ID: <20080702075459.44334db9@zod.rchland.ibm.com>
In-Reply-To: <200807020240.03443.vda.linux@googlemail.com>
References: <200807020240.03443.vda.linux@googlemail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 02:40:03 +0200
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> The purpose of this patch is to make kernel buildable
> with "gcc -ffunction-sections -fdata-sections".
> This patch fixes ppc architecture.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

You can drop this one entirely.  arch/ppc won't exist in 2.6.27.  It
has been removed in the powerpc tree already.

josh
