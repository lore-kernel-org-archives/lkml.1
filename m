Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYBASXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYBASXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYBASX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:23:28 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51348 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYBASX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:23:27 -0500
Date: Fri, 1 Feb 2008 23:56:27 +0530
From: Sudhir Kumar <skumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: sam ravnborg <sam@ravnborg.org>,
       net-dev-mailing list <netdev@vger.kernel.org>
Subject: [BUILD FAILURE]2.6.24-git10 section type conflict
Message-ID: <20080201182627.GB14251@in.ibm.com>
Reply-To: skumar@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
I found the following kernel build failure for 2.6.24-git10
on my machine:

  CC [M]  drivers/scsi/lpfc/lpfc_attr.o
drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type
conflict
make[2]: *** [drivers/net/sis190.o] Error 1
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC [M]  drivers/scsi/lpfc/lpfc_vport.o


machine info:
[root@x330d ~]# uname -a
Linux x330d.in.ibm.com 2.6.24-rc8 #1 SMP Thu Jan 31 16:46:34 NPT 2008
i686 i686 i386 GNU/Linux

Thanks

Sudhir Kumar
Linux Technology Centre
Bangalore
