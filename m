Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYBJTzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYBJTzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYBJTze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:55:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34983 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbYBJTzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:55:33 -0500
Date: Sun, 10 Feb 2008 20:55:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Faster way to run through building single modules
Message-ID: <20080210195540.GE13733@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0802101950020.7915@fbirervta.pbzchgretzou.qr> <20080210192821.GB13733@uranus.ravnborg.org> <Pine.LNX.4.64.0802102035000.7915@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802102035000.7915@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 08:38:19PM +0100, Jan Engelhardt wrote:
> 
> On Feb 10 2008 20:28, Sam Ravnborg wrote:
> >On Sun, Feb 10, 2008 at 07:51:29PM +0100, Jan Engelhardt wrote:
> >> 
> >> I was wondering whether there is a shortcut in kbuild I can take if I 
> >> just want to rebuild one module. Currently, I have:
> >> 
> >> make net/bridge/netfilter/ebtables.ko
> >
> >Fool kbuild to think this is an external module using:
> >make M=`pwd` net/bridge/netfilter/ebtables.ko
> >
> >That should do the trick.
> 
> How would I combine that with O=? Not quite doing the right thing yet.

O=tells where to find the kernel output files.
We do not have a possibility to do so for external
modules - so they will alwys build in same dir as the source.

Bad luck :-(

	Sam
