Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXCRKji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXCRKji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXCRKji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:39:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:8897 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbXCRKjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Bl296OCuu+rLsk/b51Fi4IGQH2fVaPAhUFfpE/yRvWsQGo49qjVQL3snM+9xxDqyaYc+V+cy2t4zyMXZkryPFH+QYa0mW3C0yER+Cii8dmWn+78+uVlmAYxiBByQANQHhzjLrl9q79vkbge01jsvva7s5NIzj+FVa2RFvUk7WTw=
Message-ID: <45FD16E3.4090509@gmail.com>
Date: Sun, 18 Mar 2007 19:39:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
References: <00e801c76948$da7f0df0$2101a8c0@donald>
In-Reply-To: <00e801c76948$da7f0df0$2101a8c0@donald>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Hello,
> 
>> Yeap, more than three HSM violations in ten minutes.  That's the
>> criteria for turning off NCQ.  Good to see it working.  It look like a
>> lot because libata reports all active commands (can't help as on HSM
>> failure, there's no way to determine which caused it) and the SCSI
>> prints revalidation messages, but it's still only three errors.
>>
>> Thanks for verifying that.  I wanted to verify it works in 
>> the field as expected.
> 
> Glad to help !
> 
> Anyhow, how should I consider these "errors" ? Are they real failure that
> can affect data integrity on the disk, or some kind of "protocol" errors
> with the disk, that are covered by soft (retry or so), and don't affect
> data ?

This is NCQ protocol violation on the drive's side shown on some early
drives.  No need to worry too much about it.  The drive will just get
blacklisted for NCQ and should work fine.

-- 
tejun
