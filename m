Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZK3VSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZK3VSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZK3VSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:18:21 -0500
Received: from dsl.unpythonic.net ([206.222.212.217]:45176 "EHLO
	unpythonic.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753258AbZK3VSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:18:20 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 16:18:20 EST
Date: Mon, 30 Nov 2009 15:11:49 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: ranjith kumar <ranjithproxy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: source code of dynamic liner
Message-ID: <20091130211149.GA3290@unpythonic.net>
References: <31cff80d0911301258j1a90e40bx8b9cd14740cc6d58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31cff80d0911301258j1a90e40bx8b9cd14740cc6d58@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic loader is part of userspace, so it is not an appropriate
topic for the linux-kernel mailing list.

Your Linux distribution probably includes tools for obtaining the
source package for any installed file.  For instance, on Debian-derived
systems including Ubuntu, you can use dpkg-query and apt-get for these
tasks:

# Determine what binary package provides the file /lib/ld-linux.so.2
$ dpkg-query -S /lib/ld-linux.so.2
libc6: /lib/ld-linux.so.2

# Download and untar the related source package
$ apt-get source libc6
... (downloaded 14.5MB of files) ...
dpkg-source: extracting glibc in glibc-2.3.6
dpkg-source: unpacking glibc_2.3.6.orig.tar.gz
dpkg-source: applying ./glibc_2.3.6-0ubuntu20.5.diff.gz

Jeff
