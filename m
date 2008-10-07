Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYJGLrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYJGLrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYJGLrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:47:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52569 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbYJGLrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:47:25 -0400
Date: Tue, 7 Oct 2008 12:47:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrey Batyiev <batyiev@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: APIC misconfiguration
Message-ID: <20081007114722.GB6773@srcf.ucam.org>
References: <200810061923.09076.batyiev@gmail.com> <200810061955.28915.batyiev@gmail.com> <20081006171742.GB7317@localhost> <200810062030.42952.batyiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810062030.42952.batyiev@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 08:30:42PM +0300, Andrey Batyiev wrote:
> > hmm... don't we have any ISA quirks already? If this device support
> > PnP there should be descriptor for irq line where you could change it
> > since I don't believe it would be a first device in kernel which behave
> > not as supposed and developers has to override some configs bits.
> > Hope it help (i didn't check ISA code though -- too busy now).
> 
> Well, it seems device haven't either PnP or isapnp doesn't detect it.

It'd be more likely to be acpipnp nowadays. Does it appear anywhere in 
/sys/class/pnp?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
