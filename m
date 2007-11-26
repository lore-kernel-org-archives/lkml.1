Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbXKZB22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbXKZB22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 20:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXKZB2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 20:28:18 -0500
Received: from ozlabs.org ([203.10.76.45]:41798 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbXKZB2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 20:28:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Mon, 26 Nov 2007 12:28:14 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20071122343.446909000@suse.de> <adatznarrzc.fsf@cisco.com>
In-Reply-To: <adatznarrzc.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711261228.15155.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 November 2007 07:27:03 Roland Dreier wrote:
>  > This patch allows to export symbols only for specific modules by
>  > introducing symbol name spaces. A module name space has a white
>  > list of modules that are allowed to import symbols for it; all others
>  > can't use the symbols.
>  >
>  > It adds two new macros:
>  >
>  > MODULE_NAMESPACE_ALLOW(namespace, module);
>
> I definitely like the idea of organizing exported symbols into
> namespaces.  However, I feel like it would make more sense to have
> something like
>
> MODULE_NAMESPACE_IMPORT(namespace);

Except C doesn't have namespaces and this mechanism doesn't create them.  So 
this is just complete and utter makework; as I said before, noone's going to 
confuse all those udp_* functions if they're not in the udp namespace.

For better or worse, this is not C++.

Rusty.
