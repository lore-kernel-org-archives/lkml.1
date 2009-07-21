Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZGUQYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZGUQYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZGUQYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:24:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38990 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbZGUQYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:24:03 -0400
Subject: Re: [PATCH 1/2] VM/SELinux: require CAP_SYS_RAWIO for all
 mmap_zero operations
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, kyle@mcmartin.ca,
       cpardy@redhat.com, arnd@arndb.de
In-Reply-To: <20090721170909.6182230c@lxorguk.ukuu.org.uk>
References: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
	 <20090721160437.5bda68b4@lxorguk.ukuu.org.uk>
	 <1248189524.2654.301.camel@localhost>
	 <20090721163813.0cb5d7ab@lxorguk.ukuu.org.uk>
	 <1248191833.2654.320.camel@localhost>
	 <20090721170909.6182230c@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 12:23:14 -0400
Message-Id: <1248193394.2654.327.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 17:09 +0100, Alan Cox wrote:

> It's a really ugly problem that almost begs for better hardware
> facilities (such as the multiple independent address spaces in some
> processors)

If only we knew someone who worked at intel.....   *smile*

Are you on board with the change I propose as long as I make the address
space controlled by SELinux tunable instead of fixed at one page?  Thus
allowing one to maintain the status quo?  Yeah, still sucks for
non-selinux systems and wine, but at least there can be hardening
against a non-root local authenticated user on a default fedora
install...

-Eric

