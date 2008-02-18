Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYBRRvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYBRRvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYBRRve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:51:34 -0500
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:53466 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYBRRve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:51:34 -0500
Date: Mon, 18 Feb 2008 18:51:32 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Adrian Bunk <bunk@kernel.org>, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: mips SMBUS_PSC_BASE compile errors
Message-ID: <20080218175132.GA10548@roarinelk.homelinux.net>
References: <20080217200953.GJ1403@cs181133002.pp.htv.fi> <20080218102146.GA7282@roarinelk.homelinux.net> <20080218124947.2a768c05@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218124947.2a768c05@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Mon, Feb 18, 2008 at 12:49:47PM +0100, Jean Delvare wrote:
> On Mon, 18 Feb 2008 11:21:46 +0100, Manuel Lauss wrote:
> > > ...
> > >   CC      arch/mips/au1000/common/platform.o
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/au1000/common/platform.c:277: error: 'PSC0_BASE_ADDR' undeclared here (not in a function)
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/au1000/common/platform.c:314: warning: no previous prototype for 'au1xxx_platform_init'
> > > make[2]: *** [arch/mips/au1000/common/platform.o] Error 1
> > 
> > Thanks, here's a patch. The db1200/pb1550 defconfigs (+ i2c enabled) compile

[...]

> As the breakage came through my i2c tree, I guess I am supposed to push
> this fix as well?

Yes, please do.

Thank you!
	Manuel Lauss
