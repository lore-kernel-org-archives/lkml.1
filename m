Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYHUGcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYHUGcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYHUGcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:32:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:14066 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYHUGcJ (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F5EHJ/FW7zzVcRcfQVlJ7BkD4j/YwfoI5xJtD3ZMf7hbU+658zbAdnBoRX0Mv6NXUf
         UQEGNuOTbzl8gMz6G6lQzrvIU4evdbxoL8Iou0bQVpglwejus+K8ktWPAp8yPTsEftep
         Do5QzA+Ms9VUlgHfBr+Bs2llbcDQv2SHz666Q=
Message-ID: <ac9c93b10808202332n2654884eh877848df2da59f20@mail.gmail.com>
Date: Thu, 21 Aug 2008 08:32:08 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: jaredeh@gmail.com
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AD00C4.6060302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared, nice work!

I've also read your paper from the linux symposium
(http://ols.fedoraproject.org/OLS/Reprints-2008/hulbert-reprint.pdf)

A few questions:
- how does this benchmark compared to cramfs and squashfs in a NAND-only system
  (or is it just not a good plan to use this with NAND-only (of course
I won't get XIP with NAND, I understand that)
- would axfs be suitable as a filesystem on a ram disk?

Background for the last question is that if you do not have the memory
to retain all pages uncompressed (as you would with ramfs), this could
be a nice intermediate format.
Furthermore compared to ramfs, a filesystem on a ramdisk does not need
the initialisation during startup (decompressing the cpio file,
creating the files, copying the data), so when it comes to boot times
a filesystem on a ramdisk (e.g. axfs) could be a better choice.

Appreciate your feedback.

Frans.
