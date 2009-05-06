Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZEFH02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZEFH02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZEFH0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:26:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14768 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZEFH0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:26:17 -0400
Date: Wed, 6 May 2009 09:25:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Wolfram Sang <w.sang@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the i2c tree with the arm-current 
 tree
Message-ID: <20090506092559.2d9e53cb@hyperion.delvare>
In-Reply-To: <20090506071547.GA29466@flint.arm.linux.org.uk>
References: <20090506131031.83f1b04d.sfr@canb.auug.org.au>
	<20090506071547.GA29466@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Wed, 6 May 2009 08:15:48 +0100, Russell King wrote:
> Since defconfig updates are always going to create lots of noise, and
> the files are normally out of date, the *only* sensible way to handle
> updates is to have one tree dealing with them per architecture.
> 
> Spreading them across multiple trees and then expecting merges to sort
> out the resulting mess is unreasonable; they just change far too much
> when updates happen.  Moreover, defconfig updates should be in their
> own separate commit and not combined with other changes.

I fail to see how you can handle configuration option renames
gracefully with your proposed model.

-- 
Jean Delvare
