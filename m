Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXDUFee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXDUFee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 01:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXDUFee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 01:34:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:34002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbXDUFed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 01:34:33 -0400
Date: Fri, 20 Apr 2007 22:34:20 -0700
From: Greg KH <gregkh@suse.de>
To: Marcos Pinto <markybob@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>, Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: 2.6.20.7 locking up hard on boot
Message-ID: <20070421053420.GA10974@suse.de>
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com> <20070421013454.GB4016@stusta.de> <62eb359a0704202130p39cf24efu89dccc8437c30d25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62eb359a0704202130p39cf24efu89dccc8437c30d25@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 11:30:59PM -0500, Marcos Pinto wrote:
>  Yes, I just tried 2.6.20.3 with ACPI enabled and it booted perfectly.
>  I'm hoping this means you know what's wrong? :-)

Can you do a 'git bisect' on the versions between 2.6.20.3 and 2.6.20.7
to try to find the problem patch?

thanks,

greg k-h
