Return-Path: <linux-kernel-owner+w=401wt.eu-S966192AbXDGRkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966192AbXDGRkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966188AbXDGRkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:40:07 -0400
Received: from h80ad275a.async.vt.edu ([128.173.39.90]:42176 "EHLO
	h80ad275a.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605AbXDGRkF (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:40:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: johnrobertbanks@fastmail.fm
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: Your message of "Fri, 06 Apr 2007 19:47:36 PDT."
             <1175914056.9653.1183426876@webmail.messagingengine.com>
From: Valdis.Kletnieks@vt.edu
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070406152119.GC4228@delft.aura.cs.cmu.edu>
            <1175914056.9653.1183426876@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175967598_4736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Apr 2007 13:39:58 -0400
Message-ID: <14921.1175967598@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175967598_4736P
Content-Type: text/plain; charset=us-ascii

On Fri, 06 Apr 2007 19:47:36 PDT, johnrobertbanks@fastmail.fm said:
> On Fri, 6 Apr 2007 11:21:19 -0400, "Jan Harkes" <jaharkes@cs.cmu.edu>

> > With compression there is a pretty high probability that one corrupted
> > byte or disk block will result in loss of a considerably larger amount
> > of data. 
> 
> Bad blocks are NOT dealt with by the filesystem,... so your comment is
> irrelevant, or just plain wrong.
> 
> If your filesystem is writing to bad blocks, then throw away your
> operating system.

You know... occasionally, blocks go bad *after* you write to them.  If
you have an uncompressed filesystem, it's often possible to recover most
of the file , and just have a few 512-byte blocks of zeros, simply by
doing something like 'dd if=bad.file of=bad.file bs=512 conv=noerror'
or careful applications of 'skip=N'.  If it's compressed, you usually
can't recover the rest of a compression group if a previous block is lost.

(And for those who talk about backups - yes, taking backups is good.
However, it's the rare laptop or desktop machine that can afford the
luxury of RAID disks, and backups usually happen once a night, if that
often.  This means that if you've been working hard on something important
all day, and the disk blows chunks at 4:30PM, you *will* be suddenly very
concerned over exactly how much you can recover off the failing drive....

And yes, I'd *love* to have all my users connected to nice SAN systems that do
snapshotting and remote replication to DR sites and all that - but have you
ever *priced* a petabyte of SAN storage, the NAS gateways to serve it to users,
and upgrading several tens of thousands of network ports to Gig-E? Hint -
US$1M would get us through a pilot, and probably $5M and up to *start*
deployment. Anybody wanna buy us an EMC DMX-3? :)

http://www.emc.com/products/systems/symmetrix/DMX_series/DMX3.jsp


--==_Exmh_1175967598_4736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGF9ducC3lWbTT17ARAgoTAJ9Hg1wWgLQ47Uuk0kCh+RIiv+1/VQCg2nHw
w1Iycl0MQx6w3XtS1n0rMHA=
=aO8Q
-----END PGP SIGNATURE-----

--==_Exmh_1175967598_4736P--
