Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYJ1AG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYJ1AG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYJ1AFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:05:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:20049 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYJ1AFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hyGPmUkB/75eyC6AIoh7h5XzyANsU8Nwk94BFrhOHjLuKZd4Z7ugB4DYgAQtTC6yGI
         cVyO57uf56xRq0biJGoHFxmKJCJU/bl4W2eAZG1gw7FzKjXI0Cv0pEjC1g6x//cIoa0s
         TzSN/JxoUKt2/Gz1mybphMuD+0qzwhqXJ0XPA=
Subject: Re: [RFC PATCHv3] printk: add %pM format specifier for MAC
 addresses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, anders@anduras.de, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081027.165556.30975206.davem@davemloft.net>
References: <1225137542.5396.10.camel@brick>
	 <20081027.154736.178482850.davem@davemloft.net>
	 <1225149254.6339.4.camel@brick>
	 <20081027.165556.30975206.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 17:05:39 -0700
Message-Id: <1225152339.5526.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 16:55 -0700, David Miller wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Mon, 27 Oct 2008 16:14:14 -0700
> 
> > Did you happen to have a preference with regard to the specifier for
> > IPv6 addresses:
> > 
> > I was thinking of using %pI6 to replace NIP6() and NIP6_FMT and using
> > %#pI6 for NIP6_SEQFMT.
> > 
> > On the IPv4 side, maybe use %pI4 for network endian NIPQUAD() and NIPQUAD_FMT
> > and then %#pI4 for host-endian HIQUAD(), as displaying the IPv4 address without
> > the periods isn't useful?
> > 
> > What do you think of that?
> 
> I'm ok with the '#' modifier but remind me again what's wrong with
> using plain %p4 and %p6?

Nothing at all, just wanted to know what color bikeshed you wanted.

I'll go with %p4 %p6.

Harvey

