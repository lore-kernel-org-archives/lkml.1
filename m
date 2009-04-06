Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZDFLbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZDFLbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 07:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZDFLbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 07:31:23 -0400
Received: from india.einfochips.com ([203.88.139.151]:9126 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754819AbZDFLbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 07:31:22 -0400
Message-ID: <49D9E736.1060104@einfochips.com>
Date: Mon, 06 Apr 2009 16:57:50 +0530
From: Viral Mehta <viral.mehta@einfochips.com>
Organization: eIbfochips Ltd.
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Fwd: kmap problem]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,
I am writing a kernel module. And I am facing a problem relate to Kmap.

I am retriving Kernel Virtual Address for a specific Page using kmap() 
and then after some time I am doing kunmap().
Now, I know that kmap can give A LIMITED NUMBER OF MAPPINGS and so such 
mapping should NOT be held longer. But in my case it is absolutely 
necessary to hold more than 1024 such mappings.

The same code is NOT working on 2.6.10 kernel and IS WORKING on 2.6.18 
kernel. The system is same and there are two kernels that I am playing 
with.

My only question is what is so changed in 2.6.18 kernel from 2.6.10 that 
the same code is working and evidently kmap can hold more than 1024 
virtual address mappings.

The other thing I would like to know if there is ANY generic way to 
handle this situation in 2.6.10 kernel.

Thanks,
Viral
-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
__________________________________________________________________________


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


Email Scanned for Virus & Dangerous Content by : www.CleanMailGateway.com


