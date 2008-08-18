Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYHRAHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYHRAHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 20:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYHRAHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 20:07:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbYHRAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 20:07:35 -0400
Date: Sun, 17 Aug 2008 20:07:39 -0400
From: Rik van Riel <riel@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: david@lang.hm, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080817200739.23496033@riellaptop.surriel.com>
In-Reply-To: <20080817225844.GE21112@atrey.karlin.mff.cuni.cz>
References: <20080813125638.GB6995@ucw.cz>
	<20080813135207.CC08C3765BC@pmx1.sophos.com>
	<20080814125410.GA2262@elf.ucw.cz>
	<2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>
	<20080814223918.GC6370@elf.ucw.cz>
	<20080814200005.6b363716@bree.surriel.com>
	<20080815004335.GF13048@mit.edu>
	<1218769209.16613.31.camel@localhost.localdomain>
	<20080817221258.GC21112@atrey.karlin.mff.cuni.cz>
	<alpine.DEB.1.10.0808171542160.12859@asgard.lang.hm>
	<20080817225844.GE21112@atrey.karlin.mff.cuni.cz>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 00:58:44 +0200
Pavel Machek <pavel@suse.cz> wrote:

> Rather than modify all the applications using mmap (you can't tell if
> the other side is going to use it for shared memory... right?), we
> could simply modify all the Windows-facing applications using mmap.

If web browsers, office suites and mail clients on Windows
have certain kinds of vulnerabilities, it is safe to assume
that the same programs on Linux will have similar problems.

Can we please get rid of the idea that "Windows facing" is
where the whole malware problem is?

As for how to solve it - lets try to come up with a solution
that is reasonably high performance and can be used for more
than just malware scanning.  

Using the same code for things like HSM would be nice.
 
-- 
All rights reversed.
