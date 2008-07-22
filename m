Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYGVLIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYGVLIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYGVLIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:08:01 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:17680 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYGVLIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:08:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wXCXu4EoleZKv8WKLqxYwHnvfNWPZTpytIj1RzLMp4VxxHF9rmuYGnVRcaP+P7jZC4
         pFLUVbpkqAPduEDNGlDxup87QgD91JyiqrluZjne5EJPuAzJHYJSYG/ouLJJ55RZ3bfm
         hiTbspnclqelyh0RY+U3Sa4m78UAqiZ56ijBo=
Message-ID: <804dabb00807220407x683f0eb2we0b64821b9279e3c@mail.gmail.com>
Date: Tue, 22 Jul 2008 19:07:59 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "linuxkernelnewbies@googlegroups.com" 
	<linuxkernelnewbies@googlegroups.com>
Subject: make htmldocs errors
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make htmldocs" generated the following errors:

Warning(/sda4/download/linux_linus/linux-2.6//include/asm-x86/unaligned.h):
no structured comments found
Warning(/sda4/download/linux_linus/linux-2.6//kernel/rcupdate.c:81):
No description found for parameter 'synchronize_rcu'
Warning(/sda4/download/linux_linus/linux-2.6//kernel/rcupdate.c:81):
No description found for parameter 'call_rcu'
Error(/sda4/download/linux_linus/linux-2.6//drivers/pci/pci.c:1133):
duplicate section name 'Description'
Error(/sda4/download/linux_linus/linux-2.6//drivers/pci/pci.c:1189):
duplicate section name 'Description'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'id'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'attach_adapter'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'detach_adapter'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'detach_client'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'probe'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'remove'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'shutdown'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'suspend'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'resume'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'command'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'driver'
Warning(/sda4/download/linux_linus/linux-2.6//include/linux/i2c.h:169):
No description found for parameter 'id_table'
make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 2
make: *** [htmldocs] Error 2

Can someone explain what is the cause of the error?   Is it because
"make htmldocs" attempt to detect for description marked as "/* */"
beside the field name?

Thank you.
-- 
Regards,
Peter Teoh
