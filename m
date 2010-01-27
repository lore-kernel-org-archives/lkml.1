Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608Ab0A0MKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0A0MKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578Ab0A0MKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:10:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:21795 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0A0MKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:10:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=M5nhotv94+BL/nIuVZf7UeRWauYMmFrOAQ9qfhOji0Dx3MDq6YmZ7DpJD/DmcbZHcA
         eh3LzWEFnGcj7W8uUMRx2ZEEmhm9THYQjZBRvvd0xJ8wfVDHdGI3w/swIDXQWzw2QBFY
         pKcV6chzEAQnPsu2P6WfptXpn3FVg7PrqDfp8=
MIME-Version: 1.0
Date: Wed, 27 Jan 2010 12:10:50 +0000
Message-ID: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com>
Subject: file/extent checksums for dedup/sync...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For purposes of data deduplication and data synchronisation, it would
be a powerful tool to expose file data checksums.

Since eg BTRFS uses the crc32c algorithm [1], it's possible to compute
the file's overall CRC from the accumulation of the CRCs from all it's
extents' CRCs.

For now, exposing this via an IOCTL may be sufficient, though any
ideas for introducing it in a more standard way? (it's a pity that
when stat64 was introduced, reserved fields weren't added)

Thanks,
  Daniel

[1] http://www.research.ibm.com/haifa/satran/ips/Vince-Luben-crc32c-01.pdf
-- 
Daniel J Blueman
