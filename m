Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbXL2FmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbXL2FmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 00:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXL2Fl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 00:41:57 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:37084 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXL2Fl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 00:41:56 -0500
Date: Sat, 29 Dec 2007 11:11:13 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20071229054113.GB17426@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071228142739.GA4560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228142739.GA4560@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 09:27:39AM -0500, Vivek Goyal wrote:
> On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> > Hi Vivek,
> > 
> > I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> > kexec. It just gets stuck at "Starting new kernel".
> > 
> > It does boot normally when booted as the first kernel.
> > 
> > Any hints debugging? (x86 architecture)
> 
> I generally try few things.
> 
> - Specify earlyprintk= parameter for second kernel and see if control
>   is reaching to second kernel.
> 
> - Otherwise specify --console-serial parameter on "kexec -l" commandline
>   and it should display a message "I am in purgatory" on serial console.
>   This will just mean that control has reached at least till purgatory.
> 

Ok, so it reaches till here. I get "I'm in purgatory" on the console.

-- 
regards,
Dhaval
