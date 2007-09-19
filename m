Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbXISMnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbXISMnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXISMnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:43:32 -0400
Received: from sslsrv.de ([62.75.159.123]:37740 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbXISMnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:43:32 -0400
From: Philipp Marek <philipp@marek.priv.at>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: UML dead with current -git?
Date: Wed, 19 Sep 2007 14:43:23 +0200
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <200709181714.34035@x5> <20070918175513.GD26539@uranus.ravnborg.org> <20070919013512.GA10873@c2.user-mode-linux.org>
In-Reply-To: <20070919013512.GA10873@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191443.24158@x5>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 Jeff Dike wrote:
> On Tue, Sep 18, 2007 at 07:55:13PM +0200, Sam Ravnborg wrote:
> > Sounds to me like a known issue by you. Can you give a few more details
> > so we maybe can get it fixed?
> I believe what happened here is an x86_64 build followed by a
> UML/x86_64 build with no intervening mrproper.
Yes, after a "make mrproper" it compiles fine.
However, the .config is gone afterwards ...

> I've always considered this to be a "don't do that" sort of thing.
> However, maybe we could stick the arch of the current build somewhere
> in the tree, check that before any serious part of a subsequent
> build, and error out if $ARCH is different.
Well, on this line it may be nice to be able to put the target architecture 
somewhere ...
	make mrproper
	make menuconfig ARCH=um
	make ARCH=um
... some tweaking
	make menuconfig
and the .config is overwritten with the "wrong" architecture.
(I know about .config.bak and so on ... just a small wish)


Thank you!


Regards,

Phil

-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
