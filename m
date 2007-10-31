Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbXJaI54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbXJaI54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXJaI5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:57:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38333 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbXJaI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:57:47 -0400
Date: Wed, 31 Oct 2007 08:57:39 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 32bit builds on x86-64 host.
Message-ID: <20071031085739.GA5468@infradead.org>
References: <20071029233231.GI7793@redhat.com> <472675AC.3070509@zytor.com> <20071030131032.GA32366@infradead.org> <4727D391.6080603@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4727D391.6080603@goop.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 06:00:01PM -0700, Jeremy Fitzhardinge wrote:
> Christoph Hellwig wrote:
> > Which seems rather unnatural to me.  All other merge architectures have
> > ARCH=<archdir> where archdir is the name under arch, e.g. mips, powerpc,
> > s390.  They then have a CONFIG_FOO_64 and set the utsname and -m32/-m64
> > respectively.  It would be nice if x86 could behave like all other
> > architectures in this respect.  Especially as the behaviour of the other
> > architectures is a lot more intuitive.
> >   
> 
> Yes, that would be nice.  I keep forgetting the ARCH= in my crossbuild
> trees, and end up with strange mismashes.

That's a problem with all architectures currently.  But I think Sam has
a patch that at least stores ARCH when using objdir != srcdir builds.

