Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZAENTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZAENTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZAENTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:19:20 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:49014 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbZAENTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:19:19 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <200901052107.43341.chris@csamuel.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <1230924749.7538.35.camel@think.oraclecorp.com>
	 <20090102210104.GC496@one.firstfloor.org>
	 <200901052107.43341.chris@csamuel.org>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 08:18:58 -0500
Message-Id: <1231161538.4290.12.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.496208C5.01A3:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 21:07 +1100, Chris Samuel wrote:
> On Sat, 3 Jan 2009 8:01:04 am Andi Kleen wrote:
> 
> > When it's in mainline I suspect people will start using it for that.
> 
> Some people don't even wait for that. ;-)
> 
> Seriously though, if that is a concern can I suggest taking the btrfsdev route 
> and, if you want a real belt and braces approach, perhaps require it to have a 
> mandatory mount option specified to successfully mount, maybe "eat_my_data" ?

I think ext4dev made more sense for ext4 because people generally expect
ext* to be stable.  Btrfs doesn't quite have the reputation for
stability yet, so I don't feel we need a special -dev name for it.

But, if Andrew/Linus prefer that unstable filesystems are tagged with
-dev, I'm happy to do it.

-chris


