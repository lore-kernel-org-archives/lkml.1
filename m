Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbZJHLcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbZJHLcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 07:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbZJHLcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 07:32:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53179 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417AbZJHLcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 07:32:45 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 07:32:45 EDT
Message-ID: <4ACDCB6E.4040905@mev.co.uk>
Date: Thu, 8 Oct 2009 12:22:22 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090901)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Chou <thomas@wytron.com.tw>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Abbott <ian.abbott@mev.co.uk>
Subject: Re: [PATCH v2] ata: New PATA driver for Altera CompactFlash.
References: <1254967110-3495-1-git-send-email-thomas@wytron.com.tw> <20091008105503.6ce414f5@lxorguk.ukuu.org.uk>
In-Reply-To: <20091008105503.6ce414f5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/09 10:55, Alan Cox wrote:
> On Thu,  8 Oct 2009 09:58:30 +0800
> Thomas Chou <thomas@wytron.com.tw> wrote:
> 
>> This patch adds a new PATA driver to support the Altera SOPC Builder
>> CompactFlash component as a PATA device with support for insertion
>> and removal of CF cards.  It uses the platform driver model.
> 
> Can you explain why you remove the interface rather than the device on
> the interface when you detect a card removal ?

As the originator of the driver, the only answer I have is "I don't know
how."  I was hoping for inspiration from some of the other PATA CF
drivers, but alas, I couldn't find it.  I admit that removing the whole
ATA host is a bit on the extreme side.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
