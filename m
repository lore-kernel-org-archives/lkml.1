Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYD2WC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYD2WC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbYD2WCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:02:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40586 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbYD2WB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:01:58 -0400
Date: Tue, 29 Apr 2008 22:56:20 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, harvey.harrison@gmail.com,
       bunk@kernel.org, den@openvz.org, linux-pcmcia@lists.infradead.org,
       adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-ID: <20080429215620.GA14848@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <rdunlap@xenotime.net>, harvey.harrison@gmail.com,
	bunk@kernel.org, den@openvz.org, linux-pcmcia@lists.infradead.org,
	adobriyan@gmail.com, linux-kernel@vger.kernel.org
References: <20080429182709.GB2898@cs181133002.pp.htv.fi> <20080429201704.GA31311@flint.arm.linux.org.uk> <20080429135902.504b6362.rdunlap@xenotime.net> <1209502988.24729.31.camel@brick> <20080429140926.bb763630.akpm@linux-foundation.org> <20080429141520.7a778606.rdunlap@xenotime.net> <20080429143824.8015c502.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429143824.8015c502.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 02:38:24PM -0700, Andrew Morton wrote:
> On Tue, 29 Apr 2008 14:15:20 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > > > I believe Russell is referring to the removal of the ioctl, not the
> > > > compile breakage.
> > > > 
> > > 
> > > That would be interesting information (although I have a vague feeling that
> > > it has been discussed before).
> > 
> > Yes:  http://lkml.org/lkml/2008/2/27/291
> > (now that Harvey reminded me/us)
> 
> oh, OK, whatever, that's easy.  I dropped the old patch and queued this
> one:

I'll spend some time this coming weekend working out precisely what it
requires from the ioctl interface - maybe we can have a cut-down ioctl
interface that bolts straight on as an "add on" to the new controls
without being too invasive, while still allowing its PCMCIA bits to
work.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
