Return-Path: <linux-kernel-owner+w=401wt.eu-S935036AbXLNAJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036AbXLNAJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762550AbXLNAJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:09:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:41449 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbXLNAJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:09:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=V8EE51EtTdlQFByqd8u20KsQK8/L9wj+f2ThScIfFNGQ0QD0vLngAShH+selLH+hhoedZmEs7XC2AN3pB74nu1nx3abG4DNSyUzAFg+5gp7YAltlqulW0LOlJLOj2TRrjkc7ncrVBfBuQMpmDceT9uAjoaIkSNHxgClb5bzPZL8=
Message-ID: <2ed59cbb0712131609r38d736cay4facc07748122cdb@mail.gmail.com>
Date: Thu, 13 Dec 2007 19:09:05 -0500
From: "Zurk Tech" <zurktech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Weird subtle kernel problem (maybe kernel, maybe driver, maybe ???)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

heres what i did on two different machines -
both had vanilla 2.6.23 kernels from kernel.org, running debian etch,
all updates.
first patched with truecrypt driver. second machne loaded with LUKS
and kernel crypto enabled.
both machines create 2GB encrypted file and mounted under a directory
after formatting with mkfs.vfat.
copy files, do diffs etc and test em. both are fine reading/writing
files to encrypted space, mount and unmount fine.
i then load the jdk on both and simple java read write file program.
works great.
then i do a new File("test.txt").exists() - test.txt doesnt actually exist.
truecrypt machine return false as expected. the linux kernel LUKS
crypto machine returns true.
also moved from 32 to 64 bits -- same result. tried with different
jdks from 1.4 to 1.6 latest. same result.

i dont get it. and i dont even know how to begin to test it. is this a
kernel bug ? app bug ? driver bug ? jdk bug ? vfat bug ?
anyone help diagnose it ?
-Z-
