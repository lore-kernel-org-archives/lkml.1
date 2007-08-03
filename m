Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbXHCFFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbXHCFFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 01:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXHCFEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 01:04:54 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:41993 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbXHCFEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 01:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RR10Vr5lz5XK21tEhuNdqNrbnSIT5RA8Dm2q7TNLpkj9S/8Ipv8QxW73/IYakzfbiXENsuXEo8aKXvnBA47r3ADhYINcyBLd2DYq2ICCdt6U0KYaMLA9HXez7p0W0ZLYM6Dw3JQ84UGcrByRYUcXDq/o4qhtJ8j15bE1b/Ijmac=
Message-ID: <1a297b360708022204u4fc7603pb6baebe2bdf28618@mail.gmail.com>
Date: Fri, 3 Aug 2007 09:04:51 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: Distributed storage.
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070731171347.GA14267@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070731171347.GA14267@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> TODO list currently includes following main items:
>     * redundancy algorithm (drop me a request of your own, but it is highly
>         unlikley that Reed-Solomon based will ever be used - it is too slow
>         for distributed RAID, I consider WEAVER codes)


LDPC codes[1][2] have been replacing Turbo code[3] with regards to
communication links and we have been seeing that transition. (maybe
helpful, came to mind seeing the mention of Turbo code) Don't know how
weaver compares to LDPC, though found some comparisons [4][5] But
looking at fault tolerance figures, i guess Weaver is much better.

[1] http://www.ldpc-codes.com/
[2] http://portal.acm.org/citation.cfm?id=1240497
[3] http://en.wikipedia.org/wiki/Turbo_code
[4] http://domino.research.ibm.com/library/cyberdig.nsf/papers/BD559022A190D41C85257212006CEC11/$File/rj10391.pdf
[5] http://hplabs.hp.com/personal/Jay_Wylie/publications/wylie_dsn2007.pdf
