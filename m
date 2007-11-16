Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbXKPJ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbXKPJ4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 04:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXKPJ4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 04:56:31 -0500
Received: from ns4.abinetworks.biz ([216.218.212.66]:50139 "EHLO
	ns4.abinetworks.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbXKPJ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 04:56:30 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 04:56:30 EST
Message-ID: <473D6703.9090904@abinetworks.biz>
Date: Fri, 16 Nov 2007 10:46:43 +0100
From: Gianluca Alberici <gianluca@abinetworks.biz>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NFS Bug in 2.6.23 ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Got problems with CFS after a kernel upgrade from 2.6.20 to 2.6.23.
After a certain amount of time since cattach i get:

ios:~$ ls /opt/clear/
ls: /opt/clear/: Not a directory

stracing the command i get stat64() returning ENOTDIR.
Applications won't find the directory.

If i cd into it and ls it is like doing a refresh: everything works
again for a certain amount of time, then, again. It reminds me an old
version of CFS which used to claim: 'stale NFS file handle'.

I didnt see any NFS changes in the changeslog of 2.6.23.1 so i decided
to POST.

SOmebody can help ?

TIA

Gianluca



