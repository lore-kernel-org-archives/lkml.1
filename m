Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0BLOPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:15:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44685 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0BLOPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:15:01 -0500
Date: Fri, 12 Feb 2010 14:14:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Julien BLACHE <jb@jblache.org>
Cc: Soeren Sonnenburg <sonne@debian.org>, nicolas@boichat.ch,
       felipe_alfaro@linuxmail.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Brightness control for MacBook Pro - Nvidia 9400
Message-ID: <20100212141457.GA18714@srcf.ucam.org>
References: <1265920725.7103.7.camel@no> <878wayk8hn.fsf@sonic.technologeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wayk8hn.fsf@sonic.technologeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 12:18:28PM +0100, Julien BLACHE wrote:
> Soeren Sonnenburg <sonne@debian.org> wrote:
> 
> Hi,
> 
> > I am booting a MacBookPro5,3 using elilo and efifb. Now I'd like to use
> > pommed to control display brightness (which won't work). Digging around
> > in mbp_nvidia_bl.c I figured out that tries to control the geforce 9600M
> > instead of the currently active geforece 9400m
> 
> If you know how one can determine which GPU is active, let me know. I
> don't have this information at the moment.

There's a _DSM method in the ACPI tables that you need to execute.

> I'm not sure this method actually works without the legacy BIOS. IIRC
> that method was determined by reverse engineering the Windows drivers,
> which means the legacy BIOS was in use.

Ah, yes - sorry, I'd forgotten that this used the smi horror. nouveau 
should drive the chip brightness natively, so it's probably better to 
figure out why it's breaking rather than worry about this...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
