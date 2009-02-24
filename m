Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbZBXRs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbZBXRs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZBXRss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:48:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBXRss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:48:48 -0500
Date: Tue, 24 Feb 2009 12:48:38 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kyle McMartin <kyle@infradead.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kyle@redhat.com, roland@redhat.com,
       aoliva@redhat.com
Subject: Re: [PATCH/RFC] powerpc: avoid generating .eh_frame sections with
	gcc-4.4
Message-ID: <20090224174838.GB6690@bombadil.infradead.org>
References: <20090224065112.GA6690@bombadil.infradead.org> <20090224084034.GA11847@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224084034.GA11847@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 09:40:34AM +0100, Sam Ravnborg wrote:
> x86 has a specific ".section .eh_frame,"a",@progbits" in vdso32/int80.S as one example.
> 
> Have you analyzed all these hits?
> 

These aren't effected by the patch. All the occurances of it inside the
kernel are explicitly written for the vdso/vsyscall functionality (which
needs it, since it's mapped into a userspace task, and you obviously
might be running a debugger on it.) The other hit in x86_64 is just a
discard section of the linker script.

regards, Kyle
