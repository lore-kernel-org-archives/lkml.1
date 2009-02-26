Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZBZXS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZBZXS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZBZXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:18:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52306 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758984AbZBZXSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:18:13 -0500
Message-ID: <49A7232C.6050808@redhat.com>
Date: Thu, 26 Feb 2009 15:18:04 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: filesystem time stamp resolution
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

How can code at userlevel (e.g., glibc) determine the resolution of the
a filesystem timestamp?

Boundary condition:

- - I cannot create or modify a file since the information must also
  be available for filesystems where the caller has no write permission

- - it has to work going forward (i.e., hardcoding information is no good
  idea)

One acceptable solution (for me) would be to have directories for the
filesystem types under /proc/fs (or /sys/fs) which show this
information.  E.g.:

  /proc/fs/ext4/timestamp-resolution

Measured in nano-seconds or so.

As a bonus have symlinks like

  /proc/fs/ef53 -> /proc/fs/ext4

(i.e., map the superblock magic number to a name.  But I can live with
this missing.)

As a second bonus any help for network filesystems would be good but.

Do I miss anything that is there already?

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmnIywACgkQ2ijCOnn/RHRSDgCfUep/fJohBr8kI+iuEFbanL5C
oXYAn03tnvPse68ewluvH5qrqJj02AEG
=W6ln
-----END PGP SIGNATURE-----
