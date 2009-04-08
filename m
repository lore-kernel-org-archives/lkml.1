Return-Path: <linux-kernel-owner+w=401wt.eu-S934318AbZDHQkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbZDHQkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbZDHQkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:40:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13818 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbZDHQkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ws+uNmmlh5kv+VwHBN/O8BvlSuiOJEJWUSM3sMXBu1Rww4pOK+GyjWW+PhtfVyzv+p
         PzFZW/8LUidtx7tpLInJJ6fEAUUnqLzDLvfzy9oLPi6mq/9BZmf6BAJgEP61O4bkG87s
         WszQN9teytzjYZnAOEPY8+zHkgiHBnyr0ze3w=
Message-ID: <49DCD481.1050104@tuffmail.co.uk>
Date: Wed, 08 Apr 2009 17:44:49 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: usb-storage@lists.one-eyed-alien.net,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: usual_tables: module license 'unspecified' taints kernel.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I see this regression in v2.6.30-rc1.  I end up with a module 
"usual_tables.ko", which is loaded on boot and causes the kernel to 
complain about an unspecified license.  See subject for the exact error 
message.

I have

CONFIG_USB_STORAGE=m
CONFIG_USB_LIBUSUAL=y

Also, usb-storage doesn't seem to get loaded automatically, as it did in 
2.6.29 with the same configs.

Thanks
Alan
