Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZJFRXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZJFRXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZJFRXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:23:38 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:56190 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667AbZJFRXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:23:38 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
Date: Tue, 6 Oct 2009 19:22:59 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, hohndel@infradead.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
In-reply-To: <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061923.00723.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 17:23:00.0700 (UTC) FILETIME=[A77EC1C0:01CA46A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> - but if it is _not_ set, we'll still try to get a version from the
> underlying SCM (we actually support git, hg and SVN right now, even if
> some comments may say "git only"), and if the underlying SCM says it
> has a local version, we append just "+", so you get a version number
> like
> 
> 2.6.32-rc3+

Doesn't this leave users of the git snapshot tarballs in the cold?
That seems a serious disadvantage as different users will get different 
versions (and thus report different versions in bug reports).

The advantage of an -rc0 in the Makefile is that everybody gets it.
