Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbXEPRJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbXEPRJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762637AbXEPRJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:09:40 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:24807 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762908AbXEPRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FMGXM7Er0YYqE2VsLbQiOnabtgCNzUUCCKtn/QENVGjaRXTTMQq+8uRvPLhqz7Uiq246JTYXBjdn5qB8exbqGYsGHIsWIeO57jJ7bFR+STute6yq8hYaP+6kqC9K9uSsK9MTY7bv4A3f8hSHIlHFSdBp8cFiSjlMLSWdWSy1aiE=
Message-ID: <464B3AC3.4090204@gmail.com>
Date: Wed, 16 May 2007 19:09:23 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tjenarvi Tjenarvi <tjenarvi@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: no DRQ after issuing MULTWRITE_EXT AND PCI: Bus #0b (-#0e) is
 hidden behind transparent bridge #0a (-#0a) (try 'pci=assign-busses')
References: <466481.34138.qm@web58810.mail.re1.yahoo.com> <alpine.LFD.0.98.0705150819140.16401@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705150819140.16401@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>> Someone got this link to patch this bug, 
>> http://www.spinics.net/lists/linux-ide/msg04810.html.  Then I post 
>> another thread in 
>> http://www.linuxquestions.org/questions/showthread.php?t=551630
> 
> Have you tried it, and does that patch actually fix things for you?
> 
> That patch has not been merged, possibly because it got forgotten, but 
> possibly because it had other problems. So if you can test it and send the 
> results back to Tejun and Jeff (both Cc'd), please do.

Those patch actually is merged.  It just looks different because the
table got merged back into ich6m table after finding out ich6m has the
same issue.  Also, the patch deals only with detection.

Can you boot 2.6.21.1 with only libata drivers compiled in and report
the dmesg?  libata usually dumps more info than ide drivers so it's
easier to find out what's going on.

-- 
tejun
