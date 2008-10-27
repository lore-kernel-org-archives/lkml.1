Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbYJ0XO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbYJ0XO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYJ0XOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:14:20 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:35981 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYJ0XOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DoGj5ZSNUfQPxWvbmo1fND6XNBfb90pd6qmrLy2COM/w8GQHq0AZtBBdN7JAWgE4It
         m7U1xsHBttFh7+666fWgsrApk8tEVJbOUl3OUxISDJ333Y6T2etnXhTSLVZ0/F+uZfiC
         IHcilZY1veSSFgNJc6TcQJI/f5S/rlHVxV4FE=
Subject: Re: [RFC PATCHv3] printk: add %pM format specifier for MAC
 addresses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, anders@anduras.de, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081027.154736.178482850.davem@davemloft.net>
References: <1225124904.5440.1.camel@brick>
	 <20081027.123805.134354592.davem@davemloft.net>
	 <1225137542.5396.10.camel@brick>
	 <20081027.154736.178482850.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 16:14:14 -0700
Message-Id: <1225149254.6339.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 15:47 -0700, David Miller wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Mon, 27 Oct 2008 12:59:02 -0700
> 
> > Add format specifiers for printing out six colon-separated bytes:
> > 
> > MAC addresses (%pM):
> > xx:xx:xx:xx:xx:xx
> > 
> > %#pM is also supported and omits the colon separators.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Applied, thanks.

Did you happen to have a preference with regard to the specifier for
IPv6 addresses:

I was thinking of using %pI6 to replace NIP6() and NIP6_FMT and using
%#pI6 for NIP6_SEQFMT.

On the IPv4 side, maybe use %pI4 for network endian NIPQUAD() and NIPQUAD_FMT
and then %#pI4 for host-endian HIQUAD(), as displaying the IPv4 address without
the periods isn't useful?

What do you think of that?

Harvey

