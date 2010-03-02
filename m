Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0CBWP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:15:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55045 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753434Ab0CBWP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:15:28 -0500
Date: Tue, 2 Mar 2010 22:17:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Greg KH <gregkh@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: Memory management woes - order 1 allocation failures
Message-ID: <20100302221751.20addf02@lxorguk.ukuu.org.uk>
In-Reply-To: <20100302211603.GD11355@csn.ul.ie>
References: <alpine.DEB.2.00.1002261042020.7719@router.home>
	<84144f021002260917q61f7c255rf994425f3a613819@mail.gmail.com>
	<20100301103546.DD86.A69D9226@jp.fujitsu.com>
	<20100302172606.GA11355@csn.ul.ie>
	<20100302183451.75d44f03@lxorguk.ukuu.org.uk>
	<20100302191110.GB11355@csn.ul.ie>
	<20100302192942.GA2953@suse.de>
	<20100302211603.GD11355@csn.ul.ie>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define TTY_BUFFER_PAGE		((PAGE_SIZE  - 256) / 2)
> +#define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)

Yes agreed I missed a '-1'

Alan
