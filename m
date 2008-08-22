Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYHVV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYHVV5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbYHVV5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:57:03 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:43463 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYHVV5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:57:01 -0400
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: John Ronciak <john.ronciak@gmail.com>, Grant Coady <gcoady.lk@gmail.com>,
       linux-kernel@vger.kernel.org, neilb@suse.de, bfields@fieldses.org,
       linux-nfs@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <1219441041.27921.57.camel@localhost.localdomain>
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
	 <1219087258.7192.19.camel@localhost>
	 <1219400624.18774.67.camel@zakaz.uk.xensource.com>
	 <1219428489.6919.21.camel@localhost>
	 <1219428818.27921.43.camel@localhost.localdomain>
	 <56a8daef0808221233h68853587n6015ca7d809b17e1@mail.gmail.com>
	 <1219435207.27921.51.camel@localhost.localdomain>
	 <1219440202.9097.14.camel@localhost>
	 <1219441041.27921.57.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 14:56:53 -0700
Message-Id: <1219442213.9097.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 704FAF4792C973223B5499D268C874D19868F63B
X-UiO-SPAM-Test: remote_host: 198.95.226.240 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 2 total 6 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-22 at 22:37 +0100, Ian Campbell wrote:
> I can ssh to the server fine. The same server also serves my NFS home
> directory to the box I'm writing this from and I've not seen any trouble
> with this box at all, it's a 2.6.18-xen box.

OK... Are you able to reproduce the problem reliably?

If so, can you provide me with a binary tcpdump or wireshark dump? If
using tcpdump, then please use something like

   tcpdump -w /tmp/dump.out -s 90000 host myserver.foo.bar and port 2049

Please also try to provide a netstat dump of the current TCP connections
as soon as the hang occurs:

  netstat -t

Cheers
  Trond

