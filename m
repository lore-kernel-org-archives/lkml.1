Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbZJMRUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbZJMRUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760704AbZJMRU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:20:29 -0400
Received: from khc.piap.pl ([195.187.100.11]:48513 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760699AbZJMRU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:20:26 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, davem@davemloft.net,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] wan: pci200syn needs capability.h
References: <20091013162312.8b93998b.sfr@canb.auug.org.au>
	<20091013100016.3c9bfad7.randy.dunlap@oracle.com>
Date: Tue, 13 Oct 2009 19:19:47 +0200
In-Reply-To: <20091013100016.3c9bfad7.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Tue, 13 Oct 2009 10:00:16 -0700")
Message-ID: <m33a5n5hzg.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> Driver is missing header file capability.h:
>
> drivers/net/wan/pci200syn.c:212: error: implicit declaration of function 'capable'
> drivers/net/wan/pci200syn.c:212: error: 'CAP_NET_ADMIN' undeclared (first use in this function)

Thanks, but I think a patch for a bunch of WAN drivers has been already
posted.
-- 
Krzysztof Halasa
