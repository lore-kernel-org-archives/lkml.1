Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbYKPP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbYKPP4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYKPP4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:56:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:49405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYKPP4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:56:12 -0500
Date: Sun, 16 Nov 2008 16:56:09 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116165609.4f17fc10@kopernikus.site>
In-Reply-To: <20081116073948.02aea58c@infradead.org>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<20081116073948.02aea58c@infradead.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven [2008-11-16 07:39]:
>
> On Sun, 16 Nov 2008 15:47:45 +0100
> Bernhard Walle <bwalle@suse.de> wrote:
> 
> > While the original submission of CONFIG_STRICT_DEVMEM mentions that
> > the option has been in RHEL and Fedora for 4 years without problems,
> > that's only a half of the story. The truth is that at least RHEL
> > has /dev/crash exactly to circumvent that /dev/mem restriction. Don't
> > tell me that this is better than having that sysctl entry. ;-)
> 
> I assume /dev/crash is read only

I don't know. But if that matters, why can't we make /dev/mem
write-only for certain areas and read-only for the rest ...?

> You either want this at compile time or you don't want it at all.

Why? You don't write something about my arguments (as Alan does, even
though I disagree), you only write that you "nak" it.



Regards,
Bernhard
