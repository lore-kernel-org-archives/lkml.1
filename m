Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYHXXre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYHXXre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 19:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYHXXr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 19:47:26 -0400
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:57267 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYHXXrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 19:47:25 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
Subject: Re: Behaviour of the VM on a embedded linux
Date: Mon, 25 Aug 2008 01:35:49 +0200
User-Agent: KMail/1.9.9
Cc: "Alex Riesen" <raa.lkml@gmail.com>, linux-kernel@vger.kernel.org
References: <83116F0A4FF67A4F97BA0B6E408C48E30289D8F0@zuerich.BC-Int.NET> <81b0412b0808220559w502edf03y7f318d0f3673884@mail.gmail.com> <83116F0A4FF67A4F97BA0B6E408C48E30289D979@zuerich.BC-Int.NET>
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E30289D979@zuerich.BC-Int.NET>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808250135.50497.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On Friday 22 August 2008, Wappler Marcel wrote:
> Alex, this is the case - I do observe normal operation of the VM subsytem - it moves memory pages dynamicaly throughout the system.
> But: when I create a large file on the tmpfs a kernel OOM occurs and kills the big monolithic application instead of stealing pages
> from the application. This is the fact I'm wondering about. In the past every guy told me that code size is no problem on systems
> using MMUs because the system can steal pages which contain code of the application in situations of low memory. But in my situation
> this is not the case.

Is the application linked statically? If not, code pages might be 
mapped privately and have been written to due to relocation.

Link everything statically to avoid this.


Best Regards

Ingo Oeser

