Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab0BASjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:39:51 -0500
Received: from fieldses.org ([174.143.236.118]:48085 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab0BASju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:39:50 -0500
Date: Mon, 1 Feb 2010 13:39:58 -0500
To: =?utf-8?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NFS problems in 2.6.33-rc6: Unknown error 526
Message-ID: <20100201183958.GC16879@fieldses.org>
References: <20100131234619.0f8460b9@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100131234619.0f8460b9@werewolf.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 11:46:19PM +0100, J.A. Magallón wrote:
> Hi...
> 
> With latest kernel I get this between linux boxes with that kernel:
> 
> bran:/etc# showmount -e annwn.nfs
> Export list for annwn:
> /scratch/local 192.168.1.0/24,....

Does reverting f39bde24b275ddc45df1ed835725b609e178c7a0 help?

--b.

> bran:~# mount -v -t nfs -o tcp annwn.nfs:/scratch/local /scratch/shared
> mount.nfs: timeout set for Sun Jan 31 23:38:04 2010
> mount.nfs: trying text-based options 'tcp,addr=192.168.1.10,vers=4,clientaddr=192.168.1.1'
> mount.nfs: mount(2): Unknown error 526
> mount.nfs: Unknown error 526
> 
> NFS works fine between the client and a Solaris server, and with an older
> linux server.
> Unfortunately, all my boxes got updated, so I can not try between
> a box with latest kernel and other with previous one.
> 
> With this scenario, I blame the new kernel server code, any ideas ?
> 
> TIA
> 
> -- 
> J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
>                                          \         It's better when it's free
> Mandriva Linux release 2010.1 (Cooker) for x86_64
> Linux 2.6.32.3-desktop-0.rc2.1mnb (gcc 4.4.2 ) SMP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
