Return-Path: <linux-kernel-owner+w=401wt.eu-S1764750AbXILUXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764750AbXILUXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbXILUXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:23:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49547 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbXILUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:23:34 -0400
Date: Wed, 12 Sep 2007 22:23:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bernd Petrovitsch <bernd@firmix.at>
cc: Sam Ravnborg <sam@ravnborg.org>, Dan Stromberg <dstromberglists@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
In-Reply-To: <1189621385.31502.111.camel@tara.firmix.at>
Message-ID: <Pine.LNX.4.64.0709122222010.32380@fbirervta.pbzchgretzou.qr>
References: <pan.2007.09.12.16.13.41.195991@gmail.com> 
 <20070912170529.GA18311@uranus.ravnborg.org>  <1189617081.31502.78.camel@tara.firmix.at>
  <20070912175116.GB18311@uranus.ravnborg.org>  <1189620642.31502.104.camel@tara.firmix.at>
  <20070912181621.GA18688@uranus.ravnborg.org> <1189621385.31502.111.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 12 2007 20:23, Bernd Petrovitsch wrote:
>On Wed, 2007-09-12 at 20:16 +0200, Sam Ravnborg wrote:
>>> 
>>> But we are talking[0] about a kernel-source-$VERSION.$ARCH.rpm's 
>>> which contain the kernel sources (read: lots of .c and .h files, 
>>> etc.) - including a matching .config and after `make oldconfig` - so 
>>> that one can build out-of-tree modules after installing it with 
>>> "KSRC=" (or whatever the Makefile parameter is usually called).
>>
>> You need certain things of the kernel built before you can build 
>> external modules (if they use a sane build approach). Just including 
>> the .config with the kernel source is far from enough.
>
>ACK. That all must be done/prepared correctly for the 
>kernel-source-*.rpm. And nobody said it is trivial or easy.

Trivial as far as SUSE goes. Install the binary package and you get all 
the symvers, modvers, and everything of the O= part that is needed. That 
is because symvers are per-binary image and not per-source.

Remain the Makefiles, which are in (the big) kernel-source rpm :-/



	Jan
-- 
