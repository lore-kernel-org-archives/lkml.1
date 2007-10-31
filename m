Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXJaBAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXJaBAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXJaBAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:00:04 -0400
Received: from gw.goop.org ([64.81.55.164]:40738 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbXJaBAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:00:03 -0400
Message-ID: <4727D391.6080603@goop.org>
Date: Tue, 30 Oct 2007 18:00:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 32bit builds on x86-64 host.
References: <20071029233231.GI7793@redhat.com> <472675AC.3070509@zytor.com> <20071030131032.GA32366@infradead.org>
In-Reply-To: <20071030131032.GA32366@infradead.org>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Which seems rather unnatural to me.  All other merge architectures have
> ARCH=<archdir> where archdir is the name under arch, e.g. mips, powerpc,
> s390.  They then have a CONFIG_FOO_64 and set the utsname and -m32/-m64
> respectively.  It would be nice if x86 could behave like all other
> architectures in this respect.  Especially as the behaviour of the other
> architectures is a lot more intuitive.
>   

Yes, that would be nice.  I keep forgetting the ARCH= in my crossbuild
trees, and end up with strange mismashes.

    J
