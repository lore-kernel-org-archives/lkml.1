Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZCPK47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZCPK47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZCPK4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:56:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44835 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755130AbZCPK4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:56:48 -0400
Date: Mon, 16 Mar 2009 10:57:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gabor Kovacs <kgabor@bolyai.elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Lava dual parallel PCI card IRQ problem
Message-ID: <20090316105728.4380454c@lxorguk.ukuu.org.uk>
In-Reply-To: <200903130051.18119.kgabor@bolyai.elte.hu>
References: <200903130051.18119.kgabor@bolyai.elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 00:51:18 -0400
Gabor Kovacs <kgabor@bolyai.elte.hu> wrote:

> Hi All,
> 
> I have problems in setting up IRQ mode operation of parallel ports using 
> onboard port and a LAVA dual parallel PCI card. IRQ is needed to catch events 
> of an external instrument.

The current driver never tries to initialise IRQ support for parallel PCI
ports and never has. I am not sure why this should be the case but I can
send you a patch to see what happens if we enable it.
