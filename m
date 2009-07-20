Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZGTX22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZGTX22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZGTX21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:28:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47670 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754451AbZGTX20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:28:26 -0400
Date: Tue, 21 Jul 2009 00:28:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
 Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090721002835.5a85a2aa@lxorguk.ukuu.org.uk>
In-Reply-To: <20090720155226.GA27885@srcf.ucam.org>
References: <4A647358.1040009@shipmail.org>
	<20090720135844.GA16844@infradead.org>
	<4A648718.9000709@shipmail.org>
	<20090720161620.7b027f8d@lxorguk.ukuu.org.uk>
	<20090720155226.GA27885@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think "tightly integrated" could do with some clarification here. 
> qcserial was accepted despite not being functional without a closed 
> userspace component - an open one's since been rewritten to allow it to 

It got as far as staging with a good deal of complaint. I am not sure it
would have gotten further unfixed (with my serial/tty maintainers hat
on ;)). That however was about firmware - so a lot less tightly coupled.

> work. Do we define "tightly integrated" as "likely to cross the GPL 
> line" (potentially the case with Poulsbo, not the case with qcserial), 
> or is it a pragmatic issue? What about specialised hardware drivers that 
> only have closed applications?

Ultimately - ask a lawyer, ultimately this is a question about works and
copyright boundaries. If the hardware has only some specific proprietary
app then it sounds to me like it's not a general kernel interface so
probably isn't a good interface anyway, let alone what the code may do.

Alan
