Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYADPyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYADPyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYADPyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:54:41 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34599 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752593AbYADPyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:54:41 -0500
Date: Fri, 4 Jan 2008 21:24:15 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vivek Goyal <vgoyal@redhat.com>, hbabu@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org,
       Ingo Molnar <mingo@elte.hu>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20080104155415.GC6007@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071231150843.GB27060@redhat.com> <20080103195201.GC6392@linux.vnet.ibm.com> <200801032242.01425.rjw@sisk.pl> <20080104122816.GF4514@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104122816.GF4514@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 05:58:16PM +0530, Dhaval Giani wrote:
> On Thu, Jan 03, 2008 at 10:42:00PM +0100, Rafael J. Wysocki wrote:
> > On Thursday, 3 of January 2008, Dhaval Giani wrote:
> > > On Mon, Dec 31, 2007 at 10:08:43AM -0500, Vivek Goyal wrote:
> > > > On Sat, Dec 29, 2007 at 11:11:13AM +0530, Dhaval Giani wrote:
> > > > > On Fri, Dec 28, 2007 at 09:27:39AM -0500, Vivek Goyal wrote:
> > > > > > On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> > > > > > > Hi Vivek,
> > > > > > > 
> 
> I've no clue what I managed to do wrong last night, probably tried to boot
> 2.6.24-rc6-mm1 thinking it was 2.6.24-rc6. 2.6.24-rc6 boots, but -mm
> does not. Sorry for the noise.
> 

So I went ahead and bisected -mm, and the culprit is git-x86. It boots
fine before it, but with git-x86 applied, it fails to boot.

Ingo/Thomas, could you please point me to the git-x86 tree so that I can
bisect it? (with instructions on how to pull the -mm branch, I managed
to pull the master branch, but not the -mm branch)

-- 
regards,
Dhaval
