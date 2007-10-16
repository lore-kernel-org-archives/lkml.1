Return-Path: <linux-kernel-owner+w=401wt.eu-S935788AbXJPUXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935788AbXJPUXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbXJPUXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:23:25 -0400
Received: from 74-92-59-67-NewEngland.hfc.comcastbusiness.net ([74.92.59.67]:44784
	"EHLO shelob.surriel.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbXJPUXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:23:24 -0400
Date: Tue, 16 Oct 2007 16:23:10 -0400
From: Rik van Riel <riel@surriel.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Mark Gross <mgross@linux.intel.com>, Giacomo Catenazzi <cate@debian.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071016162310.1891914f@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0710162207540.4548@fbirervta.pbzchgretzou.qr>
References: <20071014190128.6e3cdb44@bree.surriel.com>
	<20071015170411.GB18550@linux.intel.com>
	<20071015183017.GB23130@uranus.ravnborg.org>
	<4713C582.4000504@debian.org>
	<20071016200623.GB23157@linux.intel.com>
	<Pine.LNX.4.64.0710162207540.4548@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 22:09:04 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:
> On Oct 16 2007 13:06, Mark Gross wrote:
> >
> >base function:
> >Starting from a stock distro (FC, Ubuntu, OpenSuSE...) and put down a
> >kernel.org tree and automatically create a .config with all the
> >drivers needed for the platform I'm building on.
> 
> Too easy. Since opensuse's udev loads most of the modules for your
> hardware, all that would be needed is to transform the lsmod list of
> modules plus the static options in /proc/config.gz (stuff like
> psmouse) back into kconfig options ;-)

Well, at that point it does not know whether or not you
occasionally plug in an ipod or a digital camera.

Going back from the lsmod output to all the right CONFIG
options is also not as trivial as it sounds, due to all
the dependencies there are.

This project sounds like it could be a great undergraduate
project, maybe built on top of Ketchup to automatically
fetch, configure, compile and install a working kernel :)

Are there any volunteers to write down the project
description on the kernelnewbies.org wiki?

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
