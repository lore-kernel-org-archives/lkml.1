Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYLOVgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYLOVgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYLOVgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:36:06 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:24963 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYLOVgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:36:03 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for December 15 (netlabel)
Date: Mon, 15 Dec 2008 16:35:58 -0500
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au> <4946AE5C.9040207@oracle.com>
In-Reply-To: <4946AE5C.9040207@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812151635.59170.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 December 2008 2:22:04 pm Randy Dunlap wrote:
> netlabel_domainhash fails to build when IPV6 is not enabled:
>
> build-r7133.out:/local/linsrc/linux-next-20081215/net/netlabel/netlab
>el_domainhash.c:527: error: implicit declaration of function
> 'netlbl_af6list_foreach_rcu'
> build-r7133.out:/local/linsrc/linux-next-20081215/net/netlabel/netlab
>el_domainhash.c:528: error: expected ';' before 'goto'
> build-r7133.out:make[3]: *** [net/netlabel/netlabel_domainhash.o]
> Error 1

Thanks.  I just fixed this and update the lblnet-2.6_next tree; it 
should be in tomorrow's next.

-- 
paul moore
linux @ hp
