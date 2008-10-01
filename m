Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYJADFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYJADFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYJADFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:05:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:62666 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYJADFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rP/FiGgoKrc73c7glgDRrv+x3o+z+iiM3EGKMV6Eju/d5PUgFmVGzQwoahkwC6jkLK
         ulG5NkX4/9dxkRatuRgW4vxUJLGkjZ3hmADC0fI4SUMO9/C6Qik617HjHdC36W0CNDE6
         ZwWrGR4fiEn5gSQmxHdsJF2JECuYEBiUMcZtQ=
Message-ID: <48E2E8A1.8090204@gmail.com>
Date: Wed, 01 Oct 2008 12:04:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: gettinther <gettinther@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata dvdroms fails to be recognized by MCP55 controller with
 the 2.6.26.5 kernel
References: <64630f150809291601w3511febdyc769b8871db75602@mail.gmail.com> <20080930170849.52c00228.akpm@linux-foundation.org>
In-Reply-To: <20080930170849.52c00228.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-ide)
> 
> On Tue, 30 Sep 2008 00:01:34 +0100 gettinther <gettinther@gmail.com> wrote:
> 
>> Hi,
>>
>> I'm currently trying to get the 2.6.26.5 kernel to work but cannot get
>> the sata dvdrom to be recognized by the MCP55.  The controller works
>> with the 2.6.24.4 and 2.6.25.17 kernels.  I had to use
>> CONFIG_ACPI_DOCK=y for the 2.6.25.17 but this did not work with the
>> 2.6.26.5.  The problem has been confirmed on at least 2 machines.
> 
> It's a regression.
> 
>> I have tried various boot options (pci=nomsi, acpi=off and any other
>> relevant code I could find) but nothing seems to work.  The odd thing
>> is the sata dvdrom was recognized twice by the 2.6.26.5 kernel (2
>> different kernel tests) for no apparent reason (could not get it to
>> work afterward).
>>
>> Here's the cut info for each kernel from /var/log/messages (2.6.25.17,
>> 2.6.26.5 working, 2.6.26.5 not working).  If you require further
>> information I can submit it. I don't want to put too much on the first
>> message.

Does irqpoll help?

-- 
tejun
