Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZFVWUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZFVWUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZFVWUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:20:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:37328 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZFVWUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:20:42 -0400
Subject: Re: [PATCH 06/14] Pramfs: Include files
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Chris Simmonds <chris@2net.co.uk>, Arnd Bergmann <arnd@arndb.de>,
       Marco <marco.stornelli@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090622214155.GA19332@logfs.org>
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de>
	 <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de>
	 <4A3FDBFE.8050509@2net.co.uk>  <20090622214155.GA19332@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Jun 2009 23:20:39 +0100
Message-Id: <1245709239.25547.394.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 23:41 +0200, Jörn Engel wrote:
> Four loops doing the same increment with different data types: long,
> u64, we32 (wrong-endian) and we64.  Compile with _no_ optimizations.

That's a bit of a poor test then. Especially on architectures with a
load-and-swap instruction where it really shouldn't be any slower at
all.

(Although since GCC doesn't have an __attribute__((littleendian)) I'm
not entirely sure how to entice it into _using_ said instruction for the
purpose of the test... I think the kernel does manage somehow though, if
you get the sources _just_ right.)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

