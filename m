Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbZIDVlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbZIDVlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933966AbZIDVla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:41:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:40615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933850AbZIDVl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:41:29 -0400
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, sam@ravnborg.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20090904093846.a87bd198.randy.dunlap@oracle.com>
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org>
	 <20090904144857.GA12872@elte.hu>
	 <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org>
	 <4AA13FE6.20807@zytor.com>
	 <20090904093846.a87bd198.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 22:40:56 +0100
Message-Id: <1252100456.4483.544.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 09:38 -0700, Randy Dunlap wrote:
> 
> what does ARCH=x86 mean?

A bit like ARCH=powerpc. It's the new combined architecture where 64-bit
vs. 32-bit is just a config choice. ARCH=i386 and ARCH=x86_64 are just
historical baggage, and should be dropped like ARCH=ppc and ARCH=ppc64
were.

-- 
dwmw2

