Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZGTXd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZGTXd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZGTXdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:33:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59709 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbZGTXdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:33:55 -0400
Date: Tue, 21 Jul 2009 00:33:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090720233340.GA5522@srcf.ucam.org>
References: <4A647358.1040009@shipmail.org> <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org> <20090720161620.7b027f8d@lxorguk.ukuu.org.uk> <20090720155226.GA27885@srcf.ucam.org> <20090721002835.5a85a2aa@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721002835.5a85a2aa@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:28:35AM +0100, Alan Cox wrote:
> > I think "tightly integrated" could do with some clarification here. 
> > qcserial was accepted despite not being functional without a closed 
> > userspace component - an open one's since been rewritten to allow it to 
> 
> It got as far as staging with a good deal of complaint. I am not sure it
> would have gotten further unfixed (with my serial/tty maintainers hat
> on ;)). That however was about firmware - so a lot less tightly coupled.

? It was merged directly into drivers/usb/serial.

> > work. Do we define "tightly integrated" as "likely to cross the GPL 
> > line" (potentially the case with Poulsbo, not the case with qcserial), 
> > or is it a pragmatic issue? What about specialised hardware drivers that 
> > only have closed applications?
> 
> Ultimately - ask a lawyer, ultimately this is a question about works and
> copyright boundaries. If the hardware has only some specific proprietary
> app then it sounds to me like it's not a general kernel interface so
> probably isn't a good interface anyway, let alone what the code may do.

I was more wondering about whether we had issues with code that wasn't a 
GPL concern but still depended on a closed component.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
