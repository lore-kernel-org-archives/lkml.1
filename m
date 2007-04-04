Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbXDDORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbXDDORS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXDDORS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:17:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59337 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbXDDORR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:17:17 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <17939.19585.475192.767243@cargo.ozlabs.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <1175642916.10567.24.camel@shinybook.infradead.org>
	 <17939.19585.475192.767243@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 10:16:41 -0400
Message-Id: <1175696202.2774.20.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 16:58 +1000, Paul Mackerras wrote:
> David Woodhouse writes:
> 
> > A GUI PPP dialer should be
> > listing the available serial ports in the system whatever their names
> > are.
> 
> How do you propose they do that?  Neither kppp nor gnome-ppp seem to
> be able to do that currently.  Gnome-ppp offers just /dev/modem and
> /dev/ttyS[0123].  Kppp offers those plus a whole pile of others, but
> neither found the /dev/ttyPZ[01] that I get with your patch applied.
> Gnome-ppp at least let me type in /dev/ttyPZ0, but kppp didn't seem to
> have that facility.

shinybook /shiny/git/olpc-2.6 $ ls /dev/tty[a-zA-Z]* 
/dev/ttyPZ0  /dev/ttyPZ1  /dev/ttyS0  /dev/ttyS1  /dev/ttyS2  /dev/ttyS3

If you have dialler programs which can't manage to show you the existing
serial ports, file bugs. Especially if they don't let you type device
nodes into them. Sounds like kppp wouldn't let you use USB serial ports
either -- or phones connected directly via USB.

-- 
dwmw2

