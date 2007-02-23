Return-Path: <linux-kernel-owner+w=401wt.eu-S932365AbXBWN57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbXBWN57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbXBWN57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:57:59 -0500
Received: from turtle-out.mxes.net ([216.86.168.191]:3810 "EHLO
	turtle-out.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbXBWN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:57:59 -0500
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 08:57:59 EST
Message-ID: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
Date: Fri, 23 Feb 2007 13:35:50 -0000 (GMT)
Subject: 2.6.21-rc1: framebuffer/console boot failure
From: "Andrew" <andrew@nelless.net>
To: linux-kernel@vger.kernel.org
Reply-To: "Andrew" <andrew@nelless.net>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.21-rc1 fails to boot on my machine. As soon as I switch
from grub the screen turns and remains black with no sign
of Tux or any output.

I've run a git-bisect between 2.6.20 (which works fine) and
2.6.21-rc1 and found the first bad commit to be
#59b8175c771040afcd4ad67022b0cc80c216b866 which seems bizarre
to me since this is a mostly an ARM commit.

I haven't tried to revert this commit because frankly I don't
know where to go from there with a multi-parent commit.

I'm running on on a Asus A8N-VM CSM motherboard with a single
core AMD64 processor, with a nVidia GPU in the PCI-ex slot
using the standard VESA frame buffer driver.

Relevant config's can be found here:
http://homepage.ntlworld.com/anelless/linux/2.6.21-rc1/

