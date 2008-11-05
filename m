Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYKENCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYKENCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYKENCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:02:32 -0500
Received: from eazy.amigager.de ([213.239.192.238]:37344 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYKENCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:02:31 -0500
Date: Wed, 5 Nov 2008 14:02:29 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081105130229.GA30758@dose.home.local>
Mail-Followup-To: ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105122632.GC14931@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 10:26:32 -0200, Henrique de Moraes Holschuh wrote:
> On Wed, 05 Nov 2008, Tino Keitel wrote:
> > On Wed, Nov 05, 2008 at 08:33:08 +0100, Tino Keitel wrote:
> > > I tried 2.6.28-rc3 (git a75952b) on my ThinkPad X61s, and now the fan
> > > runs at full speed after resume from suspend:
> > 
> > I forgot to look into the kernel logs for more info. Well, I found this
> > line:
> > 
> > thinkpad_acpi: restoring fan level to 0x07
> > 
> > So I guess that according to
> > 
> > ACPI: thinkpad-acpi: attempt to preserve fan state on resume
> > 
> > the attempt failed. :-)
> 
> Indeed.  Please send the full kernel output of thinkpad-acpi, showing boot,
> suspend and resume messages from the driver, please?



> Also, please tell me what is the contents of /proc/acpi/ibm/fan (and if

See the first mail. I don't touch any fan settings, everything is at
the default value.
