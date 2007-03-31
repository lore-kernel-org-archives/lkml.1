Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbXCaCxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbXCaCxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933470AbXCaCxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:53:02 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:45458 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbXCaCxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bc3nsmQMtZSa4Tutyd5UKsNMCoVuQOR0ULcZruSOJZP5aTFaGHknk+h8fWUVCp4zcQBp0DzFTrfz3topKDXyn4GBurrdUDxC9+4ARAhj4ym2BtOTajwr7pmY5bK5DJLmEDr1dJxijQSRzN0/KyDPHb4ltaI/z5sL2y9Ff8QVrMY=
Message-ID: <b6a2187b0703301952s6042fbfdu2e15e0f868a958f4@mail.gmail.com>
Date: Sat, 31 Mar 2007 10:52:59 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [3/4] 2.6.21-rc5: known regressions (v2)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Dave Jones" <davej@redhat.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Tobias Doerffel" <tobias.doerffel@gmail.com>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Soeren Sonnenburg" <kernel@nn7.de>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, "Marcus Better" <marcus@better.se>,
       adaplas@gmail.com, "Jens Axboe" <jens.axboe@oracle.com>,
       "Mike Harris" <atarimike@wavecable.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org, "Maxim Levitsky" <maximlevitsky@gmail.com>,
       tigran@aivazian.fsnet.co.uk
In-Reply-To: <20070330213220.GO14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <20070330213220.GO14134@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/07, Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : ThinkPad doesn't resume from suspend to RAM
> References : http://lkml.org/lkml/2007/2/27/80
>              http://lkml.org/lkml/2007/2/28/348
> Submitter  : Jens Axboe <jens.axboe@oracle.com>
>              Jeff Chua <jeff.chua.linux@gmail.com>
> Status     : unknown

Fixed with CONFIG_NO_HZ unset and patch from Maxim
(http://lkml.org/lkml/2007/3/29/108).

Thanks,
Jeff,
