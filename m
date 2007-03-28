Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbXC1ViG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbXC1ViG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXC1ViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:38:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40921 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752985AbXC1ViD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:38:03 -0400
Date: Wed, 28 Mar 2007 23:41:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ioan Ionita" <opslynx@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Testing patch for ALi PATA - fixes hopefully for the problems
 with ATAPI DMA
Message-ID: <20070328234151.312ef2c8@the-village.bc.nu>
In-Reply-To: <df47b87a0703281423q70d6ffd3l107bf84c325dec32@mail.gmail.com>
References: <20070327190248.01bc7e5c@the-village.bc.nu>
	<df47b87a0703281423q70d6ffd3l107bf84c325dec32@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 17:23:08 -0400
"Ioan Ionita" <opslynx@gmail.com> wrote:

> On 3/27/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> >
> > This implements two things at driver level which are implemented
> > implicitly by the old IDE layer
> >
> > - Only doing sector sized ATAPI I/O via DMA
> > - Alway writing the size values
> 
> 
> Is there a similar approach for SIS PATA ATAPI?

I'm not aware of any similar limit in the SiS hardware but you can
certainly modify the patch and apply it in the same way to the SiS driver
and see what happens
