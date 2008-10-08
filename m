Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYJHXd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYJHXd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 19:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYJHXds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 19:33:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54282 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbYJHXds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 19:33:48 -0400
Date: Wed, 8 Oct 2008 19:33:06 -0400
From: Dave Jones <davej@redhat.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: fsl_upm compile failure.
Message-ID: <20081008233306.GA31771@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Anton Vorontsov <avorontsov@ru.mvista.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
References: <20081008222815.GA20542@redhat.com> <20081008230219.GA8075@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008230219.GA8075@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 03:02:19AM +0400, Anton Vorontsov wrote:
 > Hi,
 > 
 > On Wed, Oct 08, 2008 at 06:28:15PM -0400, Dave Jones wrote:
 > > Hi Anton, 
 > >  I tried reenabling CONFIG_MTD_NAND_FSL_UPM in the Fedora kernel
 > > today (currently on 2.6.27-rc9-git1), and got the error below.
 > > 
 > > ERROR: "fsl_lbc_lock" [drivers/mtd/nand/fsl_upm.ko] undefined!
 > 
 > Weird. It works for me with mpc836x_rdk_defconfig and
 > MTD_NAND_FSL_UPM=m...
 > 
 > Hm..
 > 
 >   CC      drivers/mtd/nand/fsl_upm.mod.o
 >   LD [M]  drivers/mtd/nand/fsl_upm.ko
 > 
 > Can you send me the .config file you use?
 
http://davej.fedorapeople.org/ppc.config

 > But the patch looks obviously correct. Much thanks for catching this.
 > 
 > Though better option would be to uninline the fsl_upm_run_pattern()..
 > it is quite big anyway... Something like this:

I'll leave it to you to decide what to push to Linus

	Dave

-- 
http://www.codemonkey.org.uk
