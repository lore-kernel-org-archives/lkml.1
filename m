Return-Path: <linux-kernel-owner+w=401wt.eu-S1031045AbXDJQ0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031045AbXDJQ0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031047AbXDJQ0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:26:13 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59149 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031045AbXDJQ0M (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:26:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
In-Reply-To: Your message of "Tue, 10 Apr 2007 17:54:54 +0200."
             <Pine.LNX.4.61.0704101750420.21664@yvahk01.tjqt.qr>
From: Valdis.Kletnieks@vt.edu
References: <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com> <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org> <1176121897.6210.8.camel@heimdal.trondhjem.org> <20070409131918.GC18580@thunk.org> <1176127395.6210.34.camel@heimdal.trondhjem.org> <20070410135641.GG13650@thunk.org> <1176215836.14442.37.camel@heimdal.trondhjem.org>
            <Pine.LNX.4.61.0704101750420.21664@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1176222345_4023P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Apr 2007 12:25:45 -0400
Message-ID: <9520.1176222345@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1176222345_4023P
Content-Type: text/plain; charset=us-ascii

On Tue, 10 Apr 2007 17:54:54 +0200, Jan Engelhardt said:

> NFS server sends the whole directory contents on NFS client opendir,
> so that the whole readdir/telldir/seekdir magic can happen on the
> client only... which would perhaps also enable a cheap telldir/seekdir,
> and would also give a 'fixed view' when adding/deleting files
> during readdir.

What should happen if the directory contents go stale?  If *two* systems
cache the directory and then proceed to add/delete files, what happens?

--==_Exmh_1176222345_4023P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGG7qJcC3lWbTT17ARAo9GAJ9IZoCvT3gY7gWvdHU32S9PJFWILACfQw5X
2LQlNaoETol8yn8hke7Rh7Y=
=8JQX
-----END PGP SIGNATURE-----

--==_Exmh_1176222345_4023P--
