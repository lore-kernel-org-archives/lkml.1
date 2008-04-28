Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbYD1EVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbYD1EVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 00:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYD1EU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 00:20:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYD1EUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 00:20:50 -0400
Message-ID: <4815509A.9040802@redhat.com>
Date: Sun, 27 Apr 2008 21:20:42 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: i2c or eeprom enumeration problem
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On a NUMA system the eeprom interface in /sys

  /sys/bus/i2c/drivers/eeprom/*

do not list all the DRAM eeproms.  Only the DRAM from one node is
listed.  I have a 4 socket system with all 16 banks filled and see only
4 entries.

My suspicion (without looking at any code) is that the list of i2c
devices with eeproms is collected once and this happens only on one CPU.
 I sees not to be dynamic since when I read the files with taskset
restricting execution on certain sockets and cores the result doesn't
change.

Is this known or expected (I hope not the latter)?  Where should I look
at?  I assume that's in the i2c code?

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIFVCa2ijCOnn/RHQRAhA6AJwN9Mc7HzmLM4EgWunC9eucPsDcTwCgtExK
rsz/RJMFHQMB+zIX/WuE2M8=
=OQfT
-----END PGP SIGNATURE-----
