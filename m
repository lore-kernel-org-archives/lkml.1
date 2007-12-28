Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXL1TzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXL1TzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbXL1TzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:55:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbXL1TzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:55:08 -0500
Date: Fri, 28 Dec 2007 14:54:45 -0500
From: Neil Horman <nhorman@redhat.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20071228195445.GA6245@hmsendeavour.rdu.redhat.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228124532.GB32643@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> Hi Vivek,
> 
> I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> kexec. It just gets stuck at "Starting new kernel".
> 
> It does boot normally when booted as the first kernel.
> 
> Any hints debugging? (x86 architecture)
> 
> -- 
> regards,
> Dhaval
> 
Out of curiosity, how are you booting the kexec kernel?  Are you doing a kexec
-l, or a kexec -p, followed by a system panic?  If its the later, what are you
doing to panic the system?  sysrq-c, custom module executing explicit
crash-code, hang followed by nmi panic?

Regards
Neil

> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
