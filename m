Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbYDWJce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbYDWJce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYDWJcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:32:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:1563 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYDWJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:32:25 -0400
Subject: Re: [Linux-fbdev-devel] [PATCH 1/3] radeonfb: Fix 64 bits
	resources on 32 bits archs
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
To: benh@kernel.crashing.org
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       Hollis Blanchard <hollisb@us.ibm.com>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, Detlev Zundel <dzu@denx.de>,
       Wolfgang Denk <wd@denx.de>
In-Reply-To: <1208902903.9640.138.camel@pasglop>
References: <20080422012723.BA9F2DE13F@ozlabs.org>
	 <480E0A54.9010203@linux.vnet.ibm.com>  <1208902903.9640.138.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Organization: Tungsten Graphics
Date: Wed, 23 Apr 2008 11:32:07 +0200
Message-Id: <1208943127.5632.324.camel@thor.sulgenrain.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 08:21 +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2008-04-22 at 17:55 +0200, Christian Ehrhardt wrote:
> > I wanted to ask if there are any known workarounds atm that would
> > allow me to use my X11 for now?
> 
> X is doing a mmap of /dev/mem instead of /dev/fb ?
> 
> You can normally map the fb mapping /dev/fb and then map the registers
> using /dev/fb at an offset beyond the framebuffer (fix->smem_len).
> 
> If X is using /dev/mem instead, then it's being stupid and needs to be
> fixed...

It's up to the driver, and again, the current radeon driver doesn't use
radeonfb at all anymore...


-- 
Earthling Michel Dänzer           |          http://tungstengraphics.com
Libre software enthusiast         |          Debian, X and DRI developer

