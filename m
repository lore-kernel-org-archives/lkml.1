Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbYHLEO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbYHLEO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 00:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbYHLEOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 00:14:51 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35873 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYHLEOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 00:14:50 -0400
Message-ID: <48A10E51.6030505@keyaccess.nl>
Date: Tue, 12 Aug 2008 06:15:13 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] PNP: make the resource type an unsigned long
References: <489BEA31.3040101@keyaccess.nl> <200808111559.01575.bjorn.helgaas@hp.com>
In-Reply-To: <200808111559.01575.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-08 23:59, Bjorn Helgaas wrote:

> On Friday 08 August 2008 12:39:45 am Rene Herman wrote:
>> Andrew earlier commented that pci_resourec_flags() returns an unsigned 
>> long. Had this hanging around a local branch. Useful?
> 
> I see hpa's point that it makes no functional difference, but I do
> think it's worthwhile to make the types match.  I don't want to
> debug the problem that happens when somebody adds an IORESOURCE_*
> flag in the upper bits.
> 
> You probably want to send this (and the next one, which is really
> a pci_resource_flags() usage despite being in drivers/pnp/quirks.c)
> to Andi Kleen.
> 
> Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Okay, thanks. I see that Andrew picked these up with Andi in CC so I'll 
assume things will find their way from there.

Rene.



