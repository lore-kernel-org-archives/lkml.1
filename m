Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbXF2W3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbXF2W3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXF2W3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:29:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47200 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbXF2W3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:29:39 -0400
Subject: Re: how to determine if the noexec stack is defined by an
	application
From: Arjan van de Ven <arjan@infradead.org>
To: Andreas Schwab <schwab@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <jefy4aflvs.fsf@sykes.suse.de>
References: <46856F24.5060407@andrei.myip.org>
	 <1183153758.2894.1.camel@laptopd505.fenrus.org>
	 <jefy4aflvs.fsf@sykes.suse.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 29 Jun 2007 15:27:47 -0700
Message-Id: <1183156068.2894.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-30 at 00:15 +0200, Andreas Schwab wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > like this:
> >
> > $ eu-readelf -l /bin/true  | grep STACK
> >   GNU_STACK      0x000000 0x00000000 0x00000000 0x000000 0x000000 RW 0x4
> >
> >
> > (replace /bin/true with the binary or library you want to check)
> >
> > if it says "RW" like here, it'll have non-executable stack. If it says
> > "RWX" or if this line is absent entirely, the stack will be executable.
> 
> The last part is not true.  Some architectures (especially newer ones)
> default to non-exec stack.  The absense of a GNU_STACK header represents
> the default.

ok you're right; powerpc64 defaults to non-executable stack
(all others default to executable stack)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

