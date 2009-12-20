Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZLTT3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZLTT3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZLTT3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:29:41 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:60272 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbZLTT3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:29:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R9EVRK7BBR7RpoNn4EaIDGJKdl5KM+ubWlW8pmBAD2lS09se0Hy8l3Fi7t056QgiXj
         joH4tSz4hvjQ6KyewvcA/GVKmVfh470vOhyqsjh0njSFOMqb3ARfijSnYMIqtV3s88Xn
         2yIivQw/xI5MiyTQxz33VtiRoxCoxmmqLNGeE=
Message-ID: <4B2E7B21.4070907@gmail.com>
Date: Sun, 20 Dec 2009 13:29:37 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: jidanni@jidanni.org
CC: 561764@bugs.debian.org, linux-kernel@vger.kernel.org,
       561229@bugs.debian.org
Subject: Re: Bug#561764: some warnings fly off screen and are not saved in
 any file
References: <87skb5zgri.fsf@jidanni.org>
In-Reply-To: <87skb5zgri.fsf@jidanni.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2009 11:39 AM, jidanni@jidanni.org wrote:
> OK, via
> $ zcat /boot/initrd.img-2.6.32-trunk-686|strings|less
> I think I found one of the messages I saw:
> SYSFS{}= will be removed in a future udev version
> which is in /sbin/udevadm ... bug #561229 perhaps.
>
> However, what I'm saying is "how bad it is that there be any messages
> that fly off the screen at boot and are not also 'remembered into some
> log file' one can read later?".
>
> Either remember all messages into those /var/log/ files, or remember
> none. Remembering 95% makes one think that they see all of them.
>
> There is some step so early in the boot process that recording has not
> been turned on yet. That step is making error messages that fly off the
> screen... with only one small laptop one is not going to be able to see these
> messages. One should not be required to attach other equipment to see them.

Not sure why this is CCed to LKML, the kernel isn't responsible for 
logging anything to files..
