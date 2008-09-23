Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYIWFpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYIWFpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYIWFpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:45:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:31016 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYIWFpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c20s2+mFE6GYgpAsYtPpcOmQCCyoUGSVvl3Z/KVf64Qm5olGtpRj0B8wLnsMsA4OrX
         qc/Z01jBCSXdauFerMWg8fRmT6QjndlyqyorXkluRVP1qzLYkpM+1ibdVPrzFyi+wyvj
         1Nt0nCT669vBo1xElAT/iC93hxanKtQGjF1RI=
Subject: Re: SCTP checksum patch for 2.6.26.5
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: David Miller <davem@davemloft.net>, nickolay@protei.ru,
       linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20080923051920.GD24654@1wt.eu>
References: <48D7C0A2.9090406@protei.ru>
	 <20080922.131245.193705447.davem@davemloft.net>
	 <20080923051920.GD24654@1wt.eu>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 22:45:18 -0700
Message-Id: <1222148718.16003.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 07:19 +0200, Willy Tarreau wrote:
> On Mon, Sep 22, 2008 at 01:12:45PM -0700, David Miller wrote:
> > From: Nickolay Vinogradov <nickolay@protei.ru>
> > Date: Mon, 22 Sep 2008 19:58:26 +0400
> > 
> > CC:'ing correct mailing lists...
> > 
> Nickolay,
> 
> you should use swab32(~crc32) instead. It will make use of arch-specific
> optimisations when available (eg: bswap on x86).
> 
> Willy

Or look at:
commit 336d3262df71fcd2661180bb35d5ea41b4cbca58
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Fri Jul 18 23:07:09 2008 -0700

    sctp: remove unnecessary byteshifting, calculate directly in big-endian

In Linus' tree.

Cheers,

Harvey

