Return-Path: <linux-kernel-owner+w=401wt.eu-S1750887AbZKZBa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887AbZKZBa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbZKZBa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:30:27 -0500
Received: from usul.overt.org ([204.11.33.43]:41347 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZKZBa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:30:26 -0500
Date: Wed, 25 Nov 2009 17:30:19 -0800
From: Philip Langdale <philipl@overt.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Port ricoh_mmc from driver to pci quirk.
Message-ID: <20091125173019.74d0ddb9@fido2.homeip.net>
In-Reply-To: <1259192401.15916.48.camel@maxim-laptop>
References: <1259021583.16650.9.camel@maxim-laptop>
	<20091123162119.3777e14d@fido2.homeip.net>
	<1259160947.10147.1.camel@maxim-laptop>
	<1259161121.10147.4.camel@maxim-laptop>
	<20091125085324.1ef9ae1f@fido2.homeip.net>
	<20091125113501.1f4d42b9.akpm@linux-foundation.org>
	<1259192401.15916.48.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009 01:40:01 +0200
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

 
> Of course, I can put that under config condition, that users that are
> sure that have no such device could save few hundreds of bytes.
> However a distro probably will enable this option.

Yeah, this is the only way I can think of to make it optional - and
i guess we could actually reuse the current CONFIG value to make it
transparent. I kind of like this, but there's no precedent for it
in PCI quirks as far as I can tell.
 
> I also agree that I need to print some notice to user about device
> being disabled.
> 
> Aside from being almost an 1:1 copy of original driver, this patch was
> sort of RFC, so I update it soon.

Thanks!

--phil
