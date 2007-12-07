Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbXLGEqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbXLGEqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXLGEqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:46:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:43366 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbXLGEp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:45:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MEFDpL7mrC5mvx2eb3r8dUn9SMeQX5yu/2dUiPHPlbsiNSo0B2b/PfGf1LWeBn/glSsVwNjlQJiLT9j4eWts/jfBPM8rtJNsR1AeVcyoUaIlGQk9WQs4tE0DB41tdAFm2iMb31xA7cGGSLrxu8JPuHra6SHzoK87zhulNkVilFk=
Message-ID: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
Date: Thu, 6 Dec 2007 23:45:58 -0500
From: Shane <gnome42@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc3-git4 NFS crossmnt regression
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The NFS crossmnt/nohide feature has been working beautifully
in 2.6.23. NFS in general has been really good in 2.6.23. Thanks!

However, starting in  2.6.24-rc3-git4, I immediately get 'NFS Stale
file handle' messages for any accesses to the NFS crossmnt'ed
volumes. Regular NFS mounts are fine but the crossmnt'ed
subdirs return only that error message.

2.6.24-rc3-git1 is last known good kernel. The problem also exists
with the latest snap 2.6.24-rc4-git4. NFS server is 2.6.23-rc9 and
is unchanged.

It is easily reproducible here, hopefully for the person who
knows how to debug it too :)

Shane
