Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbZFNByA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbZFNByA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 21:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZFNBxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 21:53:53 -0400
Received: from host238.190-226-77.telecom.net.ar ([190.226.77.238]:49368 "EHLO
	burns.springfield.home" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751113AbZFNBxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 21:53:53 -0400
X-Greylist: delayed 1301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2009 21:53:52 EDT
Date: Sat, 13 Jun 2009 22:32:11 -0300
From: Leandro Lucarella <llucax@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: NILFS2 get stuck after bio_alloc() fail
Message-ID: <20090614013211.GA22552@homero.springfield.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
sometimes they got stucked in D state, and the kernel had said the
following message:

        NILFS: IO error writing segment

A friend gave me a hand and after adding some printk()s we found out that
the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
fail, making it return NULL; but we don't know how that causes the
processes to get stucked.

PS: Please CC me.

-- 
Leandro Lucarella (luca) | Blog colectivo: http://www.mazziblog.com.ar/blog/
----------------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
