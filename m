Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbXC1JLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbXC1JLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933691AbXC1JLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:11:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47748 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933662AbXC1JLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:11:47 -0400
Date: Wed, 28 Mar 2007 10:57:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070328105754.72b578bd@the-village.bc.nu>
In-Reply-To: <20070328000851.GA25551@srcf.ucam.org>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
	<20070328000851.GA25551@srcf.ucam.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 01:08:52 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, Mar 23, 2007 at 07:13:21PM +0000, Alan Cox wrote:
> > For reference this is what I am currently using with 2.6.21-rc4-mm1 and
> > it is working for all my test cases so far: Its basically Kyle's patch
> > with a libata switch to turn it on/off and some minor fixups from
> > the original patch as posted
> 
> Fails for me on a Macbook Pro with:

Ok thanks. This is interesting as the only thing new it is doing is
asking for the HPA size. Does I think explain the problem however: Can
you move the HPA setting call to after the mode has been set and see if
that makes the problem vanish ?
