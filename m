Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbZFWF54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbZFWF54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZFWF5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:57:45 -0400
Received: from lazybastard.de ([212.112.238.170]:41736 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZFWF5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:57:44 -0400
Date: Tue, 23 Jun 2009 07:57:35 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Simmonds <chris@2net.co.uk>, Arnd Bergmann <arnd@arndb.de>,
       Marco <marco.stornelli@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Message-ID: <20090623055735.GA23119@logfs.org>
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de> <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de> <4A3FDBFE.8050509@2net.co.uk> <20090622214155.GA19332@logfs.org> <1245709239.25547.394.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245709239.25547.394.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 June 2009 23:20:39 +0100, David Woodhouse wrote:
> On Mon, 2009-06-22 at 23:41 +0200, Jörn Engel wrote:
> > Four loops doing the same increment with different data types: long,
> > u64, we32 (wrong-endian) and we64.  Compile with _no_ optimizations.
> 
> That's a bit of a poor test then. Especially on architectures with a
> load-and-swap instruction where it really shouldn't be any slower at
> all.
> 
> (Although since GCC doesn't have an __attribute__((littleendian)) I'm
> not entirely sure how to entice it into _using_ said instruction for the
> purpose of the test... I think the kernel does manage somehow though, if
> you get the sources _just_ right.)

Feel free to improve the test.  It is admittedly crap and designed to
support Chris' argument.  But seeing that it still fails to do so and
Arnd has already shown one improvement that weakened Chris' argument, I
guess we can all agree that further improvments won't change the
conclusion, can we? ;)

Jörn

-- 
It's just what we asked for, but not what we want!
-- anonymous
