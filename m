Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbYFAOmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbYFAOmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYFAOmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:42:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:62536 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYFAOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=wct0CXF2hXcMpNOAitCrU3MtUMZLkGeUTtWIR8nRLvessq5Aw8/yyXzjfquxpVXWoKTBzH8WUyU7j0C5yxTumvg8BfjqNtbq4ZkuWA6IAsi2wwGMPsE4E0xzYDfhAa144ZemT5p2wKB2Q990Ykgs6LZqKNar4c229yPmo1wqiJ4=
Message-ID: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>
Date: Sun, 1 Jun 2008 07:42:04 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my ALSA intel8x0 sound card regression
Cc: "Rene Herman" <rene.herman@gmail.com>, "Len Brown" <len.brown@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My intel8x0 card stops working due to a regression; bisection and
information below.

May have relationship to this thread
http://groups.google.com/group/linux.kernel/browse_thread/thread/d5857287a36e71af/d7ae0a1490b7d142?lnk=st

http://avuton.googlepages.com/intel8x0-config.gz
http://avuton.googlepages.com/intel8x0-cpuinfo
http://avuton.googlepages.com/intel8x0-dmesg
http://avuton.googlepages.com/intel8x0-ioports
http://avuton.googlepages.com/intel8x0-lspci-vvv
http://avuton.googlepages.com/intel8x0-modules
http://avuton.googlepages.com/intel8x0-ver-linux
http://avuton.googlepages.com/intel8x0-version

commit 53052feb6ddd05cb2b5c6e89fb489bf83bbb6803
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Apr 28 16:34:15 2008 -0600

    PNP: remove pnp_mem_flags() as an lvalue

    A future change will change pnp_mem_flags() from a "#define that
    simplifies to an lvalue" to "an inline function that returns the
    flags value."

    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Acked-By: Rene Herman <rene.herman@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

-- 
avuton
--
 "I've got a fever. And the only prescription is more cowbell." --
Christopher Walken
