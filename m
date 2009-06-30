Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZF3Ogt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZF3Ogt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZF3Ogl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:36:41 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55343 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZF3Ogl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:36:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@dmesg.printk.net
Subject: Re: fanotify: the fscking all notification system
In-Reply-To: Your message of "Mon, 29 Jun 2009 16:08:45 EDT."
             <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246368155_20486P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Jun 2009 09:22:35 -0400
Message-ID: <22424.1246368155@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246368155_20486P
Content-Type: text/plain; charset=us-ascii

On Mon, 29 Jun 2009 16:08:45 EDT, Eric Paris said:

> fanotify provides two things:
> 1) a new notification system, sorta like inotify, only instead of an
> arbitrary 'watch descriptor' which userspace has to know how to map back
> to an object on the filesystem, fanotify provides an open read-only fd
> back to the original object.  It should be noted that the set of
> fanotify events is much smaller than the set of inotify events.
> 
> 2) an access system in which processes may be blocked until the fanotify
> userspace listener has decided if the operation should be allowed.

I don't care much about virus scanners - but some of us with petabytes of
disk space to manage could use tis for HSM applications.  The HSM daemon
could fanotify on the file, notice that the file accessed referred to a
special "I've been archived" stub/token, and put the file back before
giving the go-ahead to the process.

The only sticky question - does this happen early enough that the accessing
process, when un-blocked, will continue through open() and get the *new*
version of the newly restored file?

--==_Exmh_1246368155_20486P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKShGbcC3lWbTT17ARAkOZAJ90E1vEyEaFQTOJjq5RPNOc+V4CfQCg0jiL
ldeBrkECiHRW2Dek+oeQNvQ=
=YLM4
-----END PGP SIGNATURE-----

--==_Exmh_1246368155_20486P--
