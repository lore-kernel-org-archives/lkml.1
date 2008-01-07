Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbYAGGFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbYAGGFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 01:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYAGGFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 01:05:13 -0500
Received: from mail.bmlv.gv.at ([193.171.152.37]:49685 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbYAGGFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 01:05:11 -0500
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: "mconf" and help texts
Date: Mon, 7 Jan 2008 07:04:58 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200801031115.48859.philipp.marek@bmlv.gv.at> <200801070431.25688.zippel@linux-m68k.org>
In-Reply-To: <200801070431.25688.zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801070704.59100.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hell Roman!

Thank you for your answer.

On Montag, 7. Januar 2008, Roman Zippel wrote:
> On Thursday 3. January 2008, Ph. Marek wrote:
> > So I took a look at "Help", and saw that blob:
...
> > That is a _bit_ unreadable.
>
> What you see here is the internal representation of the select expression.
> To make it more easily readable, you could just cut off everything between
> && and || (it's the dependency of the symbol which does the select, the one
> before &&).
> The readable expression could be generated when needed, but it might be
> easier to just generate at the same time as the full expression (in
> menu_finalize).
>
> > As a side-node - I cannot get xconfig to work (pkg-config);
>
> Why exactly? What's the error message?
	  CHECK   qt
	*
	* Unable to find the QT3 installation. Please make sure that
	* the QT3 development package is correctly installed and
	* either install pkg-config or set the QTDIR environment
	* variable to the correct location.
	*
I didn't find a package for debian that has a qt3.pc.

> > is there some
> > way in menuconfig to see why some config option is disallowed? The
> > location tree shows some data ("-> Networking support (NET [=y])"), but
> > not for all dependencies.
>
> I don't quite understand. The dependency for option itself is above the
> location tree and the for dependencies of the dependencies you have to look
> at their individual info.
If there's some option I currently can not choose (because of the 
dependencies), I'd like to see *which* dependency (-ies) prohibit that.

If all I see is
  Depends on: NET && INET && NETFILTER && NF_CONNTRACK
I have to manually hunt down which isn't enabled.

> > [Does xconfig allow enabling them while seeing this option?]
>
> Only if you enable the missing dependency. This is insofar a little easier
> as they are linked if you enable the deubg info, so the prompt may be a
> little easier to find.
So there's no easy way to say "I want that ... aktivate that, that and this 
option as needed", and it recurses through the symbols.


Thank you!


Regards,

Phil
