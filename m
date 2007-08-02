Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbXHBCKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbXHBCKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 22:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbXHBCJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 22:09:52 -0400
Received: from koto.vergenet.net ([210.128.90.7]:58142 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXHBCJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 22:09:51 -0400
Date: Thu, 2 Aug 2007 11:09:47 +0900
From: Horms <horms@verge.net.au>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Tilman Schmidt <tilman@imap.cc>,
       linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [2/2] 2.6.23-rc1: known regressions
Message-ID: <20070802020947.GD19198@verge.net.au>
References: <46A477AF.4000309@googlemail.com> <46A47936.1090606@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A47936.1090606@googlemail.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> IA64
> 
> Subject         : Regression in serial console on ia64 after 2.6.22
> References      : http://marc.info/?l=linux-ia64&m=118483645914066&w=2
> Last known good : ?
> Submitter       : Horms <horms@verge.net.au>
> Caused-By       : Yinghai Lu <Yinghai.Lu@Sun.COM>
>                   commit 18a8bd949d6adb311ea816125ff65050df1f3f6e
> Handled-By      : ?
> Status          : unknown

This was fixed by ensuring that machvex is set up before the
serial console

a07ee86205808d36973440e68c7277f9ed63b87f in Linus' tree

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

