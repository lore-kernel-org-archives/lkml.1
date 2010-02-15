Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0BOPqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:46:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0BOPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:46:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] tun: socket filter support
Date: Mon, 15 Feb 2010 16:45:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <cover.1266144917.git.mst@redhat.com> <20100214110110.GC30182@redhat.com> <4B79673B.7050908@trash.net>
In-Reply-To: <4B79673B.7050908@trash.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151645.01410.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18cGNTxqmHIUc2rU3MjqXfCLhPKvdGN6B1wUFC
 8cqM5rm0iCrvBRFaKO+L+J+/qtvN7thWHUVHR6LSfkpyypuOMp
 yZWRyjrKv4aqfwf4mfrOw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010, Patrick McHardy wrote:
> I'm not sure how the tun socket is exposed, but won't the regular
> SO_ATTACH_FILTER/SO_DETACH_FILTER setsockopts already work for
> tun sockets?

The tun socket is not exposed at all, it's an implementation detail
of the tun/tap driver, which only has a chardev interface with
ioctl methods.

	Arnd
