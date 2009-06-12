Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZFLPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZFLPWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZFLPW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:22:26 -0400
Received: from bar.sig21.net ([80.81.252.164]:36938 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZFLPWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:22:25 -0400
Date: Fri, 12 Jun 2009 17:22:24 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.30: hibernation/swsusp stuck in disable_nonboot_cpus
Message-ID: <20090612152224.GA13864@sig21.net>
References: <20090611165608.GA4908@sig21.net> <20090611203234.GA27376@elf.ucw.cz> <20090612144227.GA4961@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612144227.GA4961@sig21.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-21-Score: -3.2 (---)
X-Spam-21-Report: No, score=-3.2 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=1.228,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 04:42:27PM +0200, Johannes Stezenbach wrote:
> On Thu, Jun 11, 2009 at 10:32:34PM +0200, Pavel Machek wrote:
> > 
> > Trying to set CONFIG_SMP=n and reproducing? Trying hibernating after
> > manually offlining CPU?
> 
> A kernel built with CONFIG_SMP=n does not boot at all.

FWIW, a kernel built with CONFIG_SMP but booted with maxcpus=0
hangs in the same way.

Johannes
