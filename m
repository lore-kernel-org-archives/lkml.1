Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZFWVQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZFWVQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZFWVPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:15:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:55388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbZFWVPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:15:50 -0400
Subject: Re: [PATCH 06/14] Pramfs: Include files
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Marco <marco.stornelli@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Tim Bird <tim.bird@am.sony.com>, Chris Simmonds <chris@2net.co.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090623192648.GB23119@logfs.org>
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de>
	 <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de>
	 <4A3FDBFE.8050509@2net.co.uk> <20090622203034.GA12587@uranus.ravnborg.org>
	 <4A3FFF17.9020701@am.sony.com> <20090623042106.GA17159@uranus.ravnborg.org>
	 <4A411319.4020108@gmail.com>  <20090623192648.GB23119@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Jun 2009 22:15:42 +0100
Message-Id: <1245791743.25547.3517.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 21:26 +0200, Jörn Engel wrote:
> Endianness is a
> different case imo.  dd may not work, but a jtag probe will happily get
> you the dump to your development machine.

And dd on /dev/mem would work, surely?

I'd definitely recommend making it fixed-endian. Not doing so for JFFS2
was a mistake I frequently regretted.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

