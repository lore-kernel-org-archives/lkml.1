Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYFCOK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYFCOK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 10:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYFCOKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 10:10:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39348 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYFCOKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 10:10:13 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-tiny@selenic.com, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>
In-Reply-To: <200806031606.29574.hs4233@mail.mn-solutions.de>
References: <48447615.5050806@am.sony.com>
	 <1212500751.16924.322.camel@pmac.infradead.org>
	 <200806031606.29574.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 15:10:05 +0100
Message-Id: <1212502205.16924.335.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 16:06 +0200, Holger Schurig wrote:
> Maybe change the Kconfig entry so that:
> 
> * with CONFIG_EMBEDDED=y it's configuration
> * with CONFIG_EMBEDDED=n it's on by default

That's what Tim's patch did (although I moved it to drivers/char/Kconfig
and made it depend on CONFIG_VT).

-- 
dwmw2

