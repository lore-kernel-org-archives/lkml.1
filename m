Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYKCPrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYKCPrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYKCPre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:47:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:31844 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbYKCPrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d8TiGes3lgJYLN1xbhbUxSex0FS/aIXaO1D/KYCqQOAzInDlwJ7bVAhsvGya0hJdg+
         M5K6ZJbho5MJuuA+nnlsHl3EjsjOoXWqberAJSbb77kIP+Vr2eVkS1h56GxX+tzegad8
         bSucoixRmF/5CS5cnLBcxkXTESyYsKJNHGAeY=
Date: Mon, 3 Nov 2008 18:50:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, giometti@linux.it, gregkh@suse.de
Subject: next-20081103: oxu210hp-hcd.c:3849: error: implicit declaration of
	function 'set_irq_type'
Message-ID: <20081103155047.GA14489@x200.localdomain>
References: <20081103183214.aac32543.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103183214.aac32543.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sparc:

drivers/usb/host/oxu210hp-hcd.c:3849: error: implicit declaration of function 'set_irq_type'

and including linux/irq.h doesn't cut it CONFIG_GENERIC_HARDIRQS aren't set.
