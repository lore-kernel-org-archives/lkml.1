Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZAKUcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZAKUcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZAKUcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:32:45 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33405 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbZAKUco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:32:44 -0500
Subject: Re: [PATCH 05/11] firewire: cdev: add ioctls for isochronous
 resource management
From: David Moore <dcm@MIT.EDU>
Reply-To: dcm@acm.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.c425621dbf524825@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
	 <tkrat.c425621dbf524825@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 12:32:29 -0800
Message-Id: <1231705949.3538.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 16:26 +0100, Stefan Richter wrote:
> Based on
>     Date: Tue, 18 Nov 2008 11:41:27 -0500
>     From: Jay Fenlason <fenlason@redhat.com>
>     Subject: [Patch V4] Add ISO resource management support
> with several changes to the ABI and implementation.  Only the part of
> the ABI which enables auto-reallocation and auto-deallocation is
> included here.
> 
> This implements ioctls for kernel-assisted allocation of isochronous
> channels and isochronous bandwidth.  The benefits are:
>   - The client does not have to have write access to the /dev/fw* device
>     corresponding to the IRM.
>   - The client does not have to perform reallocation after bus resets.
>   - Channel and bandwidth are deallocated by the kernel if the file is
>     closed before the client deallocated the resources.  Thus resources
>     are released even if the client crashes.
> 
> It is anticipated that future in-kernel code (firewire-core IRM code;
> the firewire port of firedtv), will use the fw-iso.c portions of this
> code too.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Tested-by: David Moore <dcm@acm.org>

