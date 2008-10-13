Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbYJMM0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbYJMM0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYJMM0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:26:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:4390 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYJMM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id:from
         :sender;
        b=bQq/gtR24mTN07i0rHI4Z+ADMoKX3WxFu0gJipsjGvTAGRcnwBumwbepiIWQNFO9hm
         oQFicYF0tcPVX7Fmgtc0/1C+WuoZNvlMKzRxaRSsul2sZYXVUxNzaS5AFE+R1t5CNm7C
         Ec3fR3HZeJTgUDjM9zc507FOPz9eTa3pm7lIE=
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [x86_64] Implementation differences compared to x86_32
Date: Mon, 13 Oct 2008 14:26:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810131426.20075.goretux@gmail.com>
From: Eric Lacombe <tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks again for all your answers.
I have some new questions with regard to x86_64 specificities.

- In x86_32, the physical memory is mapped on kernel land by way of 4 MB 
pages.
But for x86_64, I read that the physical memory was mapped by way of 4 KB 
pages. Is it true ? and in this case, why this choice ?

- Is the LDT used in x86_64 ?
I saw that the GDT_ENTRY_LDT is defined to 10 but when I read in the GDT at 
0x50 for the segment descriptor, there is nothing, the area is filled with 
zeros.

- Where can I find some documentation about the specifities of x86_64 compared 
to x86_32, particularly about memory management ?
Perhaps you can (or someone on the list) depict those specificities ?

Thanks in advance

	Eric
