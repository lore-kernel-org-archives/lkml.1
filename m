Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0BOPsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:48:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0BOPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:48:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/2] tun: linux socket filter support
Date: Mon, 15 Feb 2010 16:47:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100214110051.GA30182@redhat.com>
In-Reply-To: <20100214110051.GA30182@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151647.26532.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18EDltLymqNUTHlWwMsfbzZvPcG+sU7REi34yY
 sJ3OsUPfL5hMwPmrcEGsWmZbxBJnFfsIkbMpRDHH42oQ+tS6Bd
 nJIm0aYMsnOZJUCd/vUyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010, Michael S. Tsirkin wrote:
> tun module already support RX filtering, however,
> this is limited to filtering by mac address.
> For virtio host, we also need filtering by vlan.
> 
> Rather than adding this directly, it seems cleaner
> to add generic socket filter support.

Great idea, I was wondering how to do vlan filtering
in macvtap with trunk mode. I guess it would be
straightforward to do the same patch in macvtap, right?

	Arnd
