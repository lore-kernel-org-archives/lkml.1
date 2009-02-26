Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbZBZX6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbZBZX6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZBZX6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:58:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45189 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbZBZX6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:58:02 -0500
Message-ID: <49A72C78.1060306@redhat.com>
Date: Thu, 26 Feb 2009 15:57:44 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: filesystem time stamp resolution
References: <49A7232C.6050808@redhat.com> <20090226235400.GP28946@ZenIV.linux.org.uk>
In-Reply-To: <20090226235400.GP28946@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> Who said that it's not going to be dependent on the flags used to
> create and/or mount the filesystem?  IOW, what makes you think that
> knowing fs type will be enough to derive that data from?

Nothing.  Just the hope that the sanity of the users is a concern when
these features are designed.

Regardless, we need some sort of solution.  I just looked, there is
spare room in the kstatfs structure.  We could have a value returned in
a new f_tsres field or so.  That could be per mount point.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkmnLHgACgkQ2ijCOnn/RHT3FQCgnLHOPL/yItK0D7gZJv93EU0U
Dr0AmNTd35JdveTPHZ8tDUUfiltscoc=
=qIcS
-----END PGP SIGNATURE-----
