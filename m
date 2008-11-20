Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYKTTJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYKTTJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYKTTIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:08:52 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:55749 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYKTTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:08:51 -0500
Date: Thu, 20 Nov 2008 20:08:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mikael Starvik <mikael.starvik@axis.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: headers-y for machines
Message-ID: <20081120190819.GA15838@uranus.ravnborg.org>
References: <4BEA3FF3CAA35E408EA55C7BE2E61D053B05D40823@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEA3FF3CAA35E408EA55C7BE2E61D053B05D40823@xmail3.se.axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael.

On Thu, Nov 20, 2008 at 09:48:45AM +0100, Mikael Starvik wrote:
> Lets say you have arch/arm/mach-xx/include/mach/myfile.h and want to add myfile.h to header-y. How do you do that?
> 
> I tried to add 
> 
> header-y += ../../maxh-xx/
> 
> in arch/arm/include/asm/Kbuild
> 
> and then
> header-y += myfile.h in arch/arm/mach-xx/include/mach/Kbuild

When we did the header file rearrange I had not foreseen that we would export header files
located anywhere else than include/* and arch/$ARCH/include so there is
no way to properly export files located in arch/$ARCH/mach-foo/...

Do we really want to export files form this location to userspace?

	Sam
