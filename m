Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYKXUfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYKXUfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYKXUex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:34:53 -0500
Received: from mail.atheros.com ([12.36.123.2]:14889 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYKXUex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:34:53 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 24 Nov 2008 12:34:51 -0800
To: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <mcgrof@gmail.com>
Subject: [ANN] CRDA and wireless-regdb release
Message-ID: <20081124203451.GB6245@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have official releases now of wireless regulatory database and
of CRDA. Our latest is:

  * wireless-regdb-master-2008-11-17
  * crda-0.9.4

You can find both here:

http://wireless.kernel.org/download/wireless-regdb/
http://wireless.kernel.org/download/crda/

The usage of crda + regdb has allowed us to move regulatory restrictions
out from drivers in the kernel out to userspace. You can use CRDA + regdb
on kernels > 2.6.28 (or anyone using compat-wireless). CRDA and the
wireless-regdb are intended to be provided as separate packages so regulatory
rule updates can be provided without having to update the crda binary.

When packaging/building keep in mind you'll only need the regulatory.bin from
wireless-regdb. The crda binary is just a udev helper, distributions are
expected to install the provided regulatory.rules file. Users wishing to
read the installed database can use:

regdbdump /path/regulatory.bin

Users/developers wishing to patch the regulatory database can send
patches against John's wireless-regdb tree:

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git

These are automated releases based on new git tags but we will send out e-mails
when we have new releases.

For futher information please see:

http://wireless.kernel.org/en/developers/Regulatory

  Luis

