Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZFVUCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZFVUCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbZFVUCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:02:21 -0400
Received: from [87.239.71.157] ([87.239.71.157]:56994 "EHLO mail.mendo.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbZFVUCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:02:19 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 16:02:19 EDT
Message-ID: <4A3FE1BA.10908@mendo.dk>
Date: Mon, 22 Jun 2009 21:55:38 +0200
From: Thomas Petersen <thomas@mendo.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090604 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29+ NFS-Server Problem "reconnect_path: npd != pd"
References: <20090521142026.GA5566@geggus.net> <1242924599.6687.1.camel@heimdal.trondhjem.org> <20090521165751.GA4428@geggus.net> <1242927133.6687.4.camel@heimdal.trondhjem.org> <gv4463$6fn$1@ultimate100.geggus.net>
In-Reply-To: <gv4463$6fn$1@ultimate100.geggus.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sven Geggus wrote:

> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
>> So what is the underlying filesystem that you are exporting, and what
>> does your /etc/exports file look like?
> 
> The underlying filesystem is xfs and /etc/exports (unchanged) is here:
> 
> --cut--
> /home/sven	192.168.3.2(rw,no_root_squash,async,subtree_check) 192.168.3.6(rw,no_root_squash,async,subtree_check) 192.168.3.8(rw,no_root_squash,async,subtree_check)


I switched to 2.6.29 on my server yesterday. It seemed to work fine but
a few hours ago I began to get the same errors (reconnect_path: npd != pd).
I have a diskless client which received stale nfs handles and stopped
working properly. I have a laptop also which is still working ok but
that client doesn't utilize the nfs filesystems that much.

I'm using gentoo on all computers. Both clients are using 2.6.28. Server
switched from 2.6.27 to 2.6.29.
I am using XFS on the server !

There is a special thing about the server though and until I saw this
discussion I thought that was the problem:
I updated the kernel because I also replaced the hardware (except the
harddrives). I switched from an old AMD Athlon (32 bit) to an AMD Phenom
II (64 bit, 4 cores). The new kernel is compiled in 64 bit but all
userland is still the old 32 bit compiled on the old Athlon. Everything
runs through IA32 emulation.

Both clients are 32 bit machines.

In a few days I'll start to update to 64 bit userland on the server and
see if that has an effect on the problem.


Thomas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/4boACgkQOaC6N60T7rze2gCfVRHI6H5hzyC4eX80H2hywJ81
3/QAnA17/9MEO3Zm8eosOtfzU+q3sYi6
=fgT+
-----END PGP SIGNATURE-----
