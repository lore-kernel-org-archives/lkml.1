Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbZIYKBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbZIYKBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 06:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZIYKBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 06:01:43 -0400
Received: from gate.in-addr.de ([212.8.193.158]:54407 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751841AbZIYKBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 06:01:42 -0400
Date: Fri, 25 Sep 2009 11:59:08 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Neil Brown <neilb@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: lars.ellenberg@linbit.com, arjan@infradead.org, jens.axboe@oracle.com,
       hch@infradead.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       akpm@linux-foundation.org, bart.vanassche@gmail.com, davej@redhat.com,
       gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090925095908.GC28951@suse.de>
References: <20090922062034.GE22732@suse.de> <20090923203531C.fujita.tomonori@lab.ntt.co.jp> <19130.43495.807916.962040@notabene.brown> <20090924083617J.fujita.tomonori@lab.ntt.co.jp> <19132.21708.867658.970822@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19132.21708.867658.970822@notabene.brown>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-09-25T15:27:40, Neil Brown <neilb@suse.de> wrote:

> > Enterprise vendors don't pick up the latest kernel. So I think that we
> > need more.

Enterprise kernel providers tend to accept the burden of supporting
their enterprise releases. While I appreciate the thought from the
community, I think the enterprise kernels already including drbd would
be extremely happy to see it officially included.

> I don't really follow your logic, but that isn't important.  I think
> that we need to be open to deprecating old ABIs, particularly when the
> ABI is largely used by just one or two programs or libraries.  This is
> the case for md/dm/drbd and similar devices.

It is even one step beyond this here. The additional ABI effort is
raised as an objection to merging drbd, and the drbd developers and user
community is offering to depreciate it within a reasonable timeframe of
a better ABI existing (since this will be hidden in the user-space
tools), if this means that it can be merged earlier.

This is quite different from an ABI which is expected to be stable and
remain forever (even if it was just an implicit user assumption); the
expectations are set accordingly from day 0, and thus should not be a
hurdle to acceptance.


Regards,
    Lars

-- 
Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

