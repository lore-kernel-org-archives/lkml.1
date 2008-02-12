Return-Path: <linux-kernel-owner+w=401wt.eu-S1764578AbYBLTn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764578AbYBLTn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763588AbYBLTnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:43:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:34096 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763333AbYBLTm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:42:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=W8oD5A8ZmLO2Fya/dTIkmYW+yGmomT2naaHWMewjUUDOC5E5qUfoT0WRF8/FHz7DkpxPd/fL9QfBRoIrmHrgekfTRIt+9abH275t++PdldBUcGxGijzune+Uedvd358IeuDCb95rTI0P6Q5cn3XGv0KLc1c8MgIwV/bbAZ70Vh0=
Date: Tue, 12 Feb 2008 20:46:30 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib_trie: rcu_assign_pointer warning fix
Message-ID: <20080212194630.GB2803@ami.dom.local>
References: <20080211.171645.74019568.davem@davemloft.net> <20080212085714.GB2582@ff.dom.local> <20080212160729.GA9157@linux.vnet.ibm.com> <20080212193218.GA2803@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212193218.GA2803@ami.dom.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 08:32:18PM +0100, Jarek Poplawski wrote:
...
> It seems the above version of this macro uses the barrier for 0, but
> if I miss something, or for these other: documenting reasons,

...or __builtin_constants could be used for indexing (?!),

> then of
> course you are right.

Jarek P.
