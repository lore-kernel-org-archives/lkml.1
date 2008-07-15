Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYGOQhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYGOQhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYGOQhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:37:04 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:24732 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbYGOQhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:37:03 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Tue, 15 Jul 2008 18:36:56 +0200
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
Message-Id: <200807151836.57983.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jul 2008 16:37:00.0521 (UTC) FILETIME=[013CDD90:01C8E699]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, you wrote:
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

For Debian packages that's in the part of the mail you snipped.

The simple answer for my current use of dep-pkg is: I don't _have_ any 
hardware that requires firmware that's split out with current kernels.
