Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZFDNU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZFDNU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZFDNUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:20:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZFDNUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:20:20 -0400
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com
In-Reply-To: <4A26F35E.1090307@gmail.com>
References: <20090526191010.20860.75372.stgit@dev.haskins.net>
	 <20090526191539.20860.1385.stgit@dev.haskins.net>
	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>
	 <4A1D2DD8.2050709@redhat.com> <1243445144.16318.15.camel@blaa>
	 <4A1D7AFD.40004@novell.com> <1243446484.4852.13.camel@blaa>
	 <4A26F35E.1090307@gmail.com>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 14:20:15 +0100
Message-Id: <1244121615.2824.23.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, 2009-06-03 at 18:04 -0400, Gregory Haskins wrote:
> Hi Mark,
>   So with the v5 release of iosignalfd, we now have the notion of a
> "trigger", the API of which is as follows:
> 
> -----------------------
> /*!
>  * \brief Assign an eventfd to an IO port (PIO or MMIO)
>  *
>  * Assigns an eventfd based file-descriptor to a specific PIO or MMIO
>  * address range.  Any guest writes to the specified range will generate
>  * an eventfd signal.
>  *
>  * A data-match pointer can be optionally provided in "trigger" and only
>  * writes which match this value exactly will generate an event.  The length
>  * of the trigger is established by the length of the overall IO range, and
>  * therefore must be in a natural byte-width for the IO routines of your
>  * particular architecture (e.g. 1, 2, 4, or 8 bytes on x86_64).

This looks like it'll work fine for virtio-pci.

Thanks,
Mark.

