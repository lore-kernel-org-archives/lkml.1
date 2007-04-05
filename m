Return-Path: <linux-kernel-owner+w=401wt.eu-S1767132AbXDEUpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767132AbXDEUpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767301AbXDEUpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:45:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767132AbXDEUpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:45:42 -0400
Date: Thu, 5 Apr 2007 12:45:45 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: IRQ splitting
Message-ID: <20070405124545.1269b1b2@localhost>
In-Reply-To: <Pine.LNX.4.61.0704052236110.6042@yvahk01.tjqt.qr>
References: <fa.21iotKLTgoLpkKhrbSxrjy5v7hM@ifi.uio.no>
	<46150913.4000406@shaw.ca>
	<20070405122341.482f5e26@freekitty>
	<Pine.LNX.4.61.0704052236110.6042@yvahk01.tjqt.qr>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 22:37:45 +0200 (MEST)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> Hello Stephen,
> 
> On Apr 5 2007 12:23, Stephen Hemminger wrote:
> >
> >If the radeon and/or the Ethernet driver support MSI, that would split
> >out the IRQ's as well.
> 
> Would Linux do that automatically? How to find out whether a given
> device -- or device driver? -- supports MSI?
> 
> 
> Thanks,
> Jan

lspci -vv will show if hardware is capable. The device driver needs
to have code that does the necessary MSI setup, some have it but
many don't. MSI is also broken on some chipsets (mostly AMD).
