Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYLDANo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYLDANo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYLDAI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:08:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38137 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759002AbYLDAI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:08:58 -0500
Date: Thu, 4 Dec 2008 00:08:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Geoffrey McRae <geoff@rabidhost.com>, Nick Andrew <nick@nick-andrew.net>,
       linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
Message-ID: <20081204000858.6c79003a@lxorguk.ukuu.org.uk>
In-Reply-To: <1228347564.10407.18.camel@localhost.localdomain>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	<20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	<1228268657.6679.4.camel@lappy.spacevs.com>
	<20081203124252.GD11807@mail.local.tull.net>
	<1228344292.6993.27.camel@lappy.spacevs.com>
	<20081203230820.4473a162@lxorguk.ukuu.org.uk>
	<1228347564.10407.18.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, in this particular case, and with this API, perhaps not.

ptrace, patching your own binary, kill etc.

> It would be great if you could say 'limit setuid() to saved-uid + uids
> 1000-2000' or something like that.

For the fsuid

> If then the userlevel NFS server gets owned you can at least be sure
> none of the files in /bin have been modified ..

The userland nfsd uses fsuid.. thats important. Acting on behalf of
another user for file purposes does make sense. I can see a
"setfsuidlist()" call making sense too, but uid/euid/saved uid don't make
sense in this context.

Alan
