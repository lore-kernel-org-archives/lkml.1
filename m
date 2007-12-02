Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbXLBG3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbXLBG3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 01:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbXLBG3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 01:29:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54126 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbXLBG3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 01:29:34 -0500
Date: Sat, 1 Dec 2007 22:27:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Scott Noone <nwi_sub@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.9, make install doesn't work with grub anymore??
Message-ID: <20071201222720.23040d71@laptopd505.fenrus.org>
In-Reply-To: <BAY113-W62BC3D470D7BA8C731FF984730@phx.gbl>
References: <BAY113-W62BC3D470D7BA8C731FF984730@phx.gbl>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 20:51:14 -0500
Scott Noone <nwi_sub@hotmail.com> wrote:

> 
> Hello,
> 
> I downloaded the vanilla kernels 2.6.23.8 and 2.6.23.9 from
> kernel.org.  I unpacked them like I have every other kernel release.
> I compiled the kernel successfully, did the make modules and make
> modules_install with no problems.  When I did the make install I am
> told it Cannot find LILO.  The message seems to come
> from /usr/src/linux-2.6.23.9/arch/i386/boot/install.sh The script is
> correct that I don't have lilo installed, I have used grub for quite
> some time.  I don't remember having this problem with older kernels,
> sorry I don't remember one of the top of head.  Did something change
> or is: cp .config /usr/src/linux-2.6.23-9 make menuconfig make make
> modules make modules_install make install no longer adequate to
> compile and install a kernel?

Hi,

actually this isn't the fault of the kernel; the grub/lilo/etc stuff is
done by a distro specific script that just gets called from make
install...

did you happen to change distros or update something like an
initscripts or similar package recently?

Greetings,
   Arjan van de Ven

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
