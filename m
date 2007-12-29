Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbXL2F07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbXL2F07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 00:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbXL2F0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 00:26:51 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:56662 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbXL2F0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 00:26:51 -0500
Date: Sat, 29 Dec 2007 10:56:38 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Neil Horman <nhorman@redhat.com>
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20071229052638.GA17426@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071228195445.GA6245@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228195445.GA6245@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 02:54:45PM -0500, Neil Horman wrote:
> On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> > Hi Vivek,
> > 
> > I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> > kexec. It just gets stuck at "Starting new kernel".
> > 
> > It does boot normally when booted as the first kernel.
> > 
> > Any hints debugging? (x86 architecture)
> > 
> > -- 
> > regards,
> > Dhaval
> > 
> Out of curiosity, how are you booting the kexec kernel?  Are you doing a kexec
> -l, or a kexec -p, followed by a system panic?  If its the later, what are you
> doing to panic the system?  sysrq-c, custom module executing explicit
> crash-code, hang followed by nmi panic?
> 

kexec -l, followed by a normal reboot.

-- 
regards,
Dhaval
