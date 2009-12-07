Return-Path: <linux-kernel-owner+w=401wt.eu-S935439AbZLGQj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935439AbZLGQj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935361AbZLGQj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:39:27 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:61936 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934829AbZLGQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:39:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gxLk/4iVLABhGgiBcRSAFDtNCQPYE76ygTQektEkqI66TUcBdGQbGOzltGl3YibGNm
         JQ1n5BlmdEEY35Iyc4iu5acLMg5YhXoFE3K64eSG6gznnq6lkAtlTzD7FOK9iFAlyVog
         htPe4utfku6fqyW6FAhzF3TD8+Ww1JbvEjNUg=
Message-ID: <4B1D2FC3.4090003@garzik.org>
Date: Mon, 07 Dec 2009 11:39:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [git patches] libata updates for 2.6.33
References: <20091206210752.GA19268@havoc.gtf.org> <4B1D02F9.4000503@ru.mvista.com>
In-Reply-To: <4B1D02F9.4000503@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 08:28 AM, Sergei Shtylyov wrote:
> Hello.
>
> Jeff Garzik wrote:
>
>> Nothing world-shakingly-notable. Notable notables:
>
>> - TRIM work from Christoph and mkp, to make SSD life a bit better
>> - PATA fixes and updates from Bart and Alan
>> - long overdue removal of 'experimental' tag from PATA driver submenu
>> in Kconfig
>> - various bug fixes and minor updates
>
>> Please pull from 'upstream-linus' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>> upstream-linus
>
>> to receive the following updates:
>
> [...]
>
>> Alan Cox (6):
>> pata_via: Blacklist some combinations of Transcend Flash and via
>> pata_sis: Implement MWDMA for the UDMA 133 capable chips
>
> Unfortunately, this patch contains a coding mistake. Probably too late
> to correct it now though Linus hasn't pulled as yet...

Well, absence of a push does not necessarily imply absence of a pull :) 
  In fact it seems pretty normal these days that Linus collects a bunch 
of pull requests, and then pushes them out later all in one batch.

But we can revert, absolutely, given the feedback from you and Bart...

	Jeff




