Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYGAIfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYGAIfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbYGAIfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:35:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1647 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbYGAIfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=p7fSCyp2Fcwum3l7r4h4JV81TSrKLsi7+SOrxilNmMDIU/Nw3ZQ6gPS5P8k9Oi/C7d
         VqtLLmn565qQNVPlzO4FNulSKABZoNMc+Ma4J5SU0TwMyLEKUvrdkw+q448UmYP8FHdF
         N4fDxKp1KUIeQEbqZCy6AXK8JnAj/MKUySiIM=
Message-ID: <4869EC40.8070105@gmail.com>
Date: Tue, 01 Jul 2008 11:35:12 +0300
From: Ruksen INANIR <rukseninanir@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: High Memory problem on 2.4.22 Linux, 2GB ppc card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,
I am working on a PPC Motorola card, which runs Linux 2.4.22.  The card 
has 2 GB onboard memory. But with use 1456 MB of  the available memory.  
To increase the memory capacity i  need  to  increase the used memory at 
least 64 MB. With CONFIG_HIGHMEM option all of the 2 GB memory can be 
used but, but the fc driver on the card has no high memory support, so 
this caused problems.
  Then i saw that the memory is limited to 1456 by
#define MAX_LOW_MEM        0x5B000000  setting in pgtable.c.  I tried to 
increase it by 64 MB but i could only increase the value of MAX_LOW_MEM 
by 47 MB (1503 MB) without CONFIG_HIGHMEM option.

1)Is there any other setting that i should set other than     
MAX_LOW_MEM to increase the usable memory to 1520 ? Do i need  to 
change  TASK_SIZE or KERNEL_START?
2)I knew that the addressable physical memory without high memory option 
was 1 G.  How was it possible to address 1503 MB without CONFIG_HIGHMEM 
? What is the max usable memory for 2.4.22 kernel?

Thanks,
Rinanir.
