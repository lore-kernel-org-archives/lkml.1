Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbXIZGYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbXIZGYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 02:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbXIZGYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 02:24:46 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46474
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750788AbXIZGYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 02:24:45 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [Announce] Linux-tiny project revival
Date: Wed, 26 Sep 2007 01:24:41 -0500
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, Indan Zupancic <indan@nul.nu>,
       linux-tiny@selenic.com, Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <46F1645D.9050406@am.sony.com> <20070921062949.GA17131@uranus.ravnborg.org> <20070924181307.GC6800@stusta.de>
In-Reply-To: <20070924181307.GC6800@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709260124.41362.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007 1:13:07 pm Adrian Bunk wrote:
> The simplest solution that comes into my mind would be to create links
> for the source file in the output dir before calling gcc and then give
> gcc the link as input file.

The way I've been building various packages out-of-tree (including the Linux 
kernel) is:

cp -sR /path/to/actual/source/tree newdir
cd newdir
configure
make
install
cd ..
rm -rf newdir

The cp -sR creates a new tree of symlinks to the original source, and 
everything I've tried so far happily builds in such a directory.

(Yes, this breaks on cygwin.  Ask me if I care.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
