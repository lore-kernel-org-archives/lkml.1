Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbXK1Nwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbXK1Nwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXK1Nwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:52:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:4813 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbXK1Nwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:52:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Zw73GtCUPoMxZ7pBq0iZjNbW7aCfpxAFfiP6zFNLU/DU2Ke7Av6ALNGPNzgenE5QJdipt7yyeUMGncAqvVnZAcEUpSLcM6PRcxY7eiwHe167l0seiFSJajTiFTeTLdcVpXFtPJBINw5SZmLFYNwKusimcYr0AfzWelhcmABGIoY=
Message-ID: <68d904ba0711280552i4ee6637j47c7ee2f72a77661@mail.gmail.com>
Date: Wed, 28 Nov 2007 08:52:33 -0500
From: "Liam Howlett" <howlett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [Patch 0/2] Kernel: mutex_lock_killable
Cc: willy@linux.intel.com, akpm@linux-foundation.org, mingo@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series of patches add the ability to make mutex locks killable
instead of uninterruptable.

This patch set builds on willys 5 patches for TASK_KILLABLE that are
currently in mm (see http://lkml.org/lkml/2007/10/18/423 for more
details).  I have used 2.6.24-rc3 with the addition of willys patches.

The first patch adds the mutex_lock_killable to the kernel/mutex.c and
kernel/mutex.h.

The second patch is a use of the mutex_lock_killable to fs/readdir.c
to use the new mutex_lock_killable.  This was enough for a small test
application to be killable once the ethernet was pulled on an nfs
mount (please note that this does not allow a normal ls to be killed
yet).

akpm: can you take these for merge in 2.6.25?

A big thanks to Matthew for all the help on these patches.
Please CC me on any responses.

Thanks,
Liam R. Howlett
