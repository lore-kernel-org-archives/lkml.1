Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbXHHHx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbXHHHx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbXHHHxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:53:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:53104 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbXHHHxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CXLkSDKJeLXUpezV/HMIoUMqtTkSt4+dRKQeWmmJ/eLiOFlQawHCOTuAiNanUDiHm84kDY2IpDSZoa7FZvPgWFw23/hIs1X/wxG4gZPaq97iXkSY1eK7UcjFgDRTsGvIo034tI7OvRDOu4wOrnaUGEUGcwUczvXogteWcsSfQJs=
Message-ID: <46B97673.4060009@gmail.com>
Date: Wed, 08 Aug 2007 16:53:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com> <m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Cornelia Huck <cornelia.huck@de.ibm.com> writes:
> 
>> My udev failed to create /dev/dasd* so it cannot mount root :( I'm
>> currently trying to find out what causes this, may take some time...
> 
> Oh weird.
> 
> No great surprise that something goofed up given how many
> patches were involved.  Still there shouldn't have been
> any user visible differences in the patchset.
> 
> If you can narrow down which patch caused the problem that would be
> great.
> 
> Otherwise I guess I will have to start looking at the code and
> trying to guess what might have triggered this.

JFYI, your patchset works fine on my x86-64 test machine.  Corenelia
tests on a s390 system which does rename/move stuff with its devices and
usually gets hit first if something is wrong.  I'll scream if I find
anything suspicious while reviewing.

Thanks.

-- 
tejun
