Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZLZTFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZLZTFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 14:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZLZTE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 14:04:59 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:49359 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZLZTE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 14:04:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZD3mRUrvKC1KloQh1qzqjv+hCvY+dtK9vUX1FtHf1i+Kks3WdNOhRROMJg/6tgWnYC
         8bNFhw20tRIIS0LE7qbaH4tGbYOKxi8ldvvPd6vU62SUjIX6RoFbf4TeYufFR9nkZejm
         e6zsT+cOx2KNE3O6PDrJsUxnPsNfWztZ+PHSw=
Message-ID: <4B365E56.9030302@lwfinger.net>
Date: Sat, 26 Dec 2009 13:04:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: Regression in module wmi since 2.6.32 (bisected to commit 1caab3c)
References: <4B352513.90302@lwfinger.net> <200912260118.26391.carlos@strangeworlds.co.uk> <4B362C95.4040700@lwfinger.net> <200912261836.41882.carlos@strangeworlds.co.uk>
In-Reply-To: <200912261836.41882.carlos@strangeworlds.co.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2009 12:36 PM, Carlos Corbacho wrote:
> On Saturday 26 December 2009 15:32:37 Larry Finger wrote:
>>> Initial patch below which takes the "ignore all duplicate GUIDs" approach.
>>
>> The patch fixes my machine.
> 
> Can you test this instead? It should actually do the right thing.

This one worked, and I got the message that there was a duplicate in the logs.

Larry
