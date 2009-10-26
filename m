Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZJZLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZJZLRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZJZLRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:17:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47278 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbZJZLRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:17:19 -0400
Date: Mon, 26 Oct 2009 11:17:22 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Jan Ceuleers <jan.ceuleers@computer.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add WARN on sizeof(&
Message-ID: <20091026111722.GF12089@shadowen.org>
References: <20091002113038.1dc3d284@hyperion.delvare>
 <20091002.095402.42770342.davem@davemloft.net>
 <4AC77003.9090805@computer.org>
 <1254618769.1799.280.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254618769.1799.280.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 06:12:49PM -0700, Joe Perches wrote:
> On Sat, 2009-10-03 at 17:38 +0200, Jan Ceuleers wrote:
> > David Miller wrote:
> > > Any time you see "&" in a sizeof() expression, it's almost
> > > certainly a bug.  Something for the folks with automated
> > > tools to look for if they haven't already :-)
> > 
> > Your remark prompted me to find four more instances of such bugs
> > (none of which in the networking bits). I have submitted patches.
> 
> Perhaps a checkpatch test.
> 
> ---
> 
> sizeof(&foo) is frequently an error.  Warn on its use.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Seems reasonable.  A slightly modified version of this is now in my
tree.  Thanks!

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
