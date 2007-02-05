Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbXBEN5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbXBEN5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbXBEN5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:57:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480AbXBEN5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:57:45 -0500
Date: Mon, 5 Feb 2007 08:57:37 -0500
From: Dave Jones <davej@redhat.com>
To: David Liontooth <liontooth@cogweb.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Eeek! page_mapcount(page) went negative! (-1)
Message-ID: <20070205135737.GB4121@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Liontooth <liontooth@cogweb.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <45C698D1.1070208@cogweb.net> <45C6B71E.9050805@cogweb.net> <20070204211705.8cd3203b.randy.dunlap@oracle.com> <45C6CA72.6020206@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C6CA72.6020206@cogweb.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 10:10:58PM -0800, David Liontooth wrote:

 > > Two things:
 > > a.  Can you try a recent/current kernel to see if this happens?
 > > b.  The "Tainted: GF" means that a module was forcibly loaded.
 > > What module was this?  and is it compatible with a 2.6.16.38 kernel?
 > > Can you reproduce this problem without having that module loaded?
 > >   
 > Randy, thanks for responding. I discovered that the files the script was
 > operating on were corrupt, so let me see if it recurs with healthy files.
 > 
 > It's the lirc module that generates the GF flag --
 > 
 >     lirc_serial: no version for "lirc_unregister_plugin" found: kernel
 > tainted.
 > 
 > So it's not actually forced. I'll remove it if this problem recurs.
 > 
 > I've tried 2.6.18 and 2.6.19 on this box, and they are moderately stable
 > if I use acpi_use_timer_override. It's a production machine, so I can't
 > experiment much.

Which will make it awkward for my suggestion..   The box I was seeing
this on turned out to have hardware problems.  A run of memtest86 may
show up something.  Then again, maybe it won't.  The failing box
I had ran memtest86 for days without incident, despite that the
capacitors on the motherboard were oozing out their goo.

		Dave

-- 
http://www.codemonkey.org.uk
