Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZCSQWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZCSQWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZCSQWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:22:44 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42154 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZCSQWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z5x69bpF8bLSSJ3EmKIIghWo5lFDHLzfxZL1NpOxo2MIHWdvmG9JnsUzOCJWTo64Up
         xz6eaBylgXaUPxz2QyER8+vpAjiTfeSXZ5AxbhyPg6VaoopjGvvPWiLuG0EzrDUIA/M/
         NwJ2F68rBtjdy6fPqpoPwaSdqvxnCE2cDoPfQ=
Message-ID: <49C2714D.9070007@gmail.com>
Date: Thu, 19 Mar 2009 17:22:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-6.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: remove compat stuff
References: <1237364017-27361-1-git-send-email-jirislaby@gmail.com> <alpine.LNX.2.00.0903191554380.14346@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0903191554380.14346@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.3.2009 16:00, Jiri Kosina wrote:
> On Wed, 18 Mar 2009, Jiri Slaby wrote:
>
>> This removal was scheduled and there is no problem with later
>> distros to adapt for the new bus, thanks to aliases.
>>
>> module-init-tools map files are deprecated nowadays, so that
>> the patch which introduced hid ones into the m-i-t won't be
>> accepted and hence there is no reason for leaving compat stuff in.
>>
>> Signed-off-by: Jiri Slaby<jirislaby@gmail.com>
>> Cc: Jiri Kosina<jkosina@suse.cz>
>
> This seems to be against some different codebase than what I currently
> have in my tree. I have manually fixed the patch and applied it to
> upstream-compat-remove branch, please check it whether it is OK by you.

Looks good(tm). Thanks.

It was based on an -mm kernel, which contains -next's 
request_module_nowait. Sorry for that.
