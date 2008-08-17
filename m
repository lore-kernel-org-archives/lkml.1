Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYHQGAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYHQGAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 02:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYHQGAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 02:00:43 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:43957 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYHQGAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 02:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=b6Vq1GMa1nAaIRR89ipsoa/4woiUckOSJvD0/DsrS6+yWrtQlMqFPAAuXlUrNI/eSA
         lHLN69fAuka2gRWKhx4DEw/ThX1uA6HFGkWaBuMUBuj4J6ugwKaeEjaJRTaeIo/9DIJs
         ZxlMOhstlbzs6qnCPy9gBDJxaz/IdCKFYRsfU=
Message-ID: <93655eb70808162300i4286eac9p9aa34cf23359ff72@mail.gmail.com>
Date: Sun, 17 Aug 2008 11:30:41 +0530
From: "Satish Eerpini" <eerpini@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: patching kdb to Centos kernel : error
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi everyone , i was trying to patch kdb with CentOS 5.0 kernel
(2.6.18-8) , and had a few rejects ( which i am still trying to
resolve) ,.... but apart from the rejects during the kernel
compilation i got the following error which does not seem to have
anything to do with the rejects ............
i have got an error in a kdb module, which has nothing to do with the
rejected patches ( or so i guess ) :

              kdb/modules/kdbm_pg.c: In function 'kdbm_show_page':
              kdb/modules/kdbm_pg.c:349: error: implicit declaration
of function 'PageChecked'
              kdb/modules/kdbm_pg.c: In function 'kdbm_inode':
              kdb/modules/kdbm_pg.c:507: error: 'struct inode' has no
member named 'u'

 the code(in kdb/modules/kdbm_pg.c) which is causing the second error
is something like this :

             iaddr += offsetof(struct inode, u);

what i am not able to understand is that if 'u' is not a correct
member of the inode , .. then what did they( whoever wrote this piece
code) intend by 'u' ? , .....

....
and for the first error , ... i just checked out the code ....
according to the line no shown in the error .....the code is :

             kdb_page_flags(page, Checked);

and i don't see any function PageChecked ....! so what can the error
actually mean ??

Thanks in advance
Satish
--
http://satish.playdrupal.com
