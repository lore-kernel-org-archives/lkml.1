Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYGOQZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYGOQZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYGOQY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:24:59 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:3294 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175AbYGOQY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:24:59 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Tue, 15 Jul 2008 18:24:55 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <200807151757.10626.elendil@planet.nl> <20080715090441.478c2287@infradead.org>
In-Reply-To: <20080715090441.478c2287@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151824.56980.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jul 2008 16:24:57.0423 (UTC) FILETIME=[523CDDF0:01C8E697]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, Arjan van de Ven wrote:
> Frans Pop <elendil@planet.nl> wrote:
> > You release 2.6.27-rc2 and I build it. Ouch! It fails to install, at
> > least if I want to install it _alongside_ 2.6.27-rc1 or other kernels
> > (which I do!). Why does it fail? Because dpkg's package management
> > does not allow one package to overwrite files already "owned" by
> > another package.
>
> question: how do you deal with this with the dozens of drivers that use
> request_firmware() even before yesterday ?
> the answer is critical in how to deal with this "new" situation as
> well ;-)

For Debian packages that was in the part of the mail you snipped.

The simple answer for my current use of dep-pkg for custom kernels is:
I don't _have_ any hardware that requires firmware that's split out with 
current kernels.
Maybe I'll be lucky and will find that I don't have any with 2.6.27, but 
I'm not betting on that.
