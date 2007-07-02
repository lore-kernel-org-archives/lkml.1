Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbXGBSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbXGBSWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 14:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXGBSWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 14:22:10 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:24658 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbXGBSWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 14:22:08 -0400
Date: Mon, 2 Jul 2007 20:22:05 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
Message-ID: <20070702182205.GA15458@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Shaohua Li <shaohua.li@intel.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>, jamagallon@ono.com,
	tigran@aivazian.fsnet.co.uk,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com> <1174610594.6598.3.camel@sli10-conroe.sh.intel.com> <81b0412b0707020156q2dedde7fw6c46e8d626ed34a7@mail.gmail.com> <1183396710.2691.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183396710.2691.0.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-RZG-AUTH: z4gQVF2k5XWuW3CcuQaEWohSwg==
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven, Mon, Jul 02, 2007 19:18:29 +0200:
> On Mon, 2007-07-02 at 10:56 +0200, Alex Riesen wrote:
> > On 3/23/07, Shaohua Li <shaohua.li@intel.com> wrote:
> > > On Thu, 2007-03-22 at 23:45 +0000, Daniel J Blueman wrote:
> > > > Is the tool you mentioned last June [1] available for splitting up the
> > > > old firmware files to the new format (eg
> > > > /lib/firmware/intel-ucode/06-0d-06), or are updates available from
> > > > Intel (or otherwise) in this new format?
> > > Yes, we are preparing the new format data files and maybe put it into a
> > > new website. We will announce it when it's ready.
> > 
> > Well, is it ready yet?
> 
> you can use the old format still as well without any problems...
> 

only with microcode utility. The microcode driver does not load it
through firmware helper.

It is by no means a problem. It's just there is this driver, which
tries to load its firmware, does not find it and complains about it in
logs... Just an annoying message in logs, that's all:

main: error loading '/lib/firmware/intel-ucode/06-09-05' for device \
'/devices/platform/microcode/firmware/microcode' with driver \
'(unknown'

If it does not work, than maybe just remove it? They driver, or maybe
the warning.

