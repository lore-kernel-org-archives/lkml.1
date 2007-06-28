Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbXF1FPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbXF1FPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 01:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbXF1FO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 01:14:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35161 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbXF1FO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 01:14:57 -0400
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
From: Arjan van de Ven <arjan@infradead.org>
To: Patrick Draper <pdraper@gmail.com>
Cc: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4683252B.9010205@gmail.com>
References: <200706271825.17459.ahartmetz@gmail.com>
	 <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com>
	 <4682EEDD.4020501@gmail.com> <4682FE5C.5070004@gmail.com>
	 <468315AF.1080105@gmail.com>  <4683252B.9010205@gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 27 Jun 2007 22:13:34 -0700
Message-Id: <1183007614.2662.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 22:04 -0500, Patrick Draper wrote:
> Rene Herman wrote:
> > So -- the fact that mixing actually works for you when using libaoss 
> > means software mixing is working correctly for your ALSA setup. The only 
> > thing you should do is _use_ ALSA (natively) and not its OSS emulation 
> > so you can drop the library preload.
> 
> Cool. How do I go about figuring out what every app uses? For example, 
> you mentioned that the flash 9 plugin, which I also use, is an ALSA 
> aware application. How do you know? I need the check out everything that 
> I use which needs sound (vmware, skype, kmplayer, etc.) I don't have 
> source code for at least two of those.

run ldd on the binary...


