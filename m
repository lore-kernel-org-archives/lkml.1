Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYHXXze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYHXXze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 19:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYHXXz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 19:55:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:48349 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYHXXz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 19:55:26 -0400
Date: Sun, 24 Aug 2008 16:55:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>,
       "Alex Riesen" <raa.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Behaviour of the VM on a embedded linux
Message-ID: <20080824165522.16216011@infradead.org>
In-Reply-To: <200808250135.50497.ioe-lkml@rameria.de>
References: <83116F0A4FF67A4F97BA0B6E408C48E30289D8F0@zuerich.BC-Int.NET>
	<81b0412b0808220559w502edf03y7f318d0f3673884@mail.gmail.com>
	<83116F0A4FF67A4F97BA0B6E408C48E30289D979@zuerich.BC-Int.NET>
	<200808250135.50497.ioe-lkml@rameria.de>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008 01:35:49 +0200
Ingo Oeser <ioe-lkml@rameria.de> wrote:

> Is the application linked statically? If not, code pages might be 
> mapped privately and have been written to due to relocation.
> 
> Link everything statically to avoid this.

... static linking has severe downsides though. You can also just use
prelink to avoid relocations in practice.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org



