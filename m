Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZAaP0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZAaP0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 10:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZAaP0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 10:26:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49945 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZAaP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 10:26:31 -0500
Date: Sat, 31 Jan 2009 15:26:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH D 01/11] OMAP: Add clk_get_parent() for OMAP2/3
Message-ID: <20090131152620.GN1394@n2100.arm.linux.org.uk>
References: <20090128191638.16688.33452.stgit@localhost.localdomain> <20090128191807.16688.91255.stgit@localhost.localdomain> <20090129110043.GE12627@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901292327090.26985@utopia.booyaka.com> <20090131142344.GM1394@n2100.arm.linux.org.uk> <yw1xhc3f5xb9.fsf@thrashbarg.mansr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1xhc3f5xb9.fsf@thrashbarg.mansr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 03:07:06PM +0000, Måns Rullgård wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> > Great, thanks.  However, I'd forgotten that one of my patches completely
> > removes clk_get_parent() since it's unused by any code in OMAP at present.
> >
> > What was the reasoning behind making this work?
> 
> It is needed for the omapfb/dss driver to set an optimal rate for
> dpll4_m4_ck.

I assume this isn't merged yet?  Where can I see what it's doing?
