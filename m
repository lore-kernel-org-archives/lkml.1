Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYF0OWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYF0OWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYF0OWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:22:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:54838 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbYF0OWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:22:40 -0400
Date: Fri, 27 Jun 2008 07:22:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Agner Fog <agner@agner.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
Message-ID: <20080627072231.7337ba18@infradead.org>
In-Reply-To: <4864CFA5.9050901@agner.org>
References: <48626514.2040905@agner.org>
	<20080625092224.736c2541@infradead.org>
	<4862ECAB.1040402@zytor.com>
	<4864CFA5.9050901@agner.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 13:31:49 +0200
Agner Fog <agner@agner.org> wrote:

> Arjan van de Ven wrote:
> 
> >the linux kernel policy is loud and clear; this is more an OS policy
> >as it is a platform ABI issue.
> 
> It doesn't help to say it "loud and clear" in a closed mailing list.

lkml is rather public

> It has to go into an official document that people can find, and the
> ABI is the most natural place to look for such rules. The ABI is hard
> enough to find. Is there an official OS policy document somewhere
> that I haven't found? Please point me to an authoritative document.

DocBook/kernel-hacking.tmpl has a section about it.


> You can't blame driver makers for using XMM or YMM registers in
> inline assembly or intrinsic functions or calling their own libraries
> or using a different compiler unless there is an official rule
> against it written in some official document that is easy to find. If
> you want to move data in a device driver, it is tempting indeed to
> use the largest register size available.

the good news is that we review drivers before they get included and we
do catch such things. In addition, we give the compiler the command
line options that prevent it from using these instructions....
I don't think this is a problem in practice for Linux drivers.

(I'm deliberately ignoring non-opensource drivers here; you get what
you get with those; "just say no").



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
