Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbZBEUKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbZBEUKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZBEUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:10:06 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:54762 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZBEUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:10:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rab6SKJeCKctIKScTZPaPKS6e9rS8P8FHfX47XymdaImaU0Wt4GWQsdfGklc8DUYcC
         zIOAzNHNQTMRDKX68BwrN9czc5I1uHyA92wh9BfOZa9L0K7gcnaP1RFkqFCv+qtz9QAt
         ooZ/tJMe9jhKzx8VLV0z63Al5vTRbSrR+79rM=
MIME-Version: 1.0
In-Reply-To: <20090205195459.GB2617@uranus.ravnborg.org>
References: <56e1b5710902050047h2c58eec7l812a838491a0256a@mail.gmail.com>
	 <56e1b5710902050057r598f03ddhf3de4aa835071832@mail.gmail.com>
	 <20090205195459.GB2617@uranus.ravnborg.org>
Date: Thu, 5 Feb 2009 21:10:02 +0100
Message-ID: <56e1b5710902051210o75401c75nfc3797c2465897fb@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Enable the gcc flag -Wformat-security (was: Re: 
	[PATCH] Kbuild: Disable the -Wformat-security gcc flag)
From: Floris Kraak <randakar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 8:54 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Feb 05, 2009 at 09:57:28AM +0100, Floris Kraak wrote:
>> On Thu, Feb 5, 2009 at 9:47 AM, Floris Kraak <randakar@gmail.com> wrote:
>>
>> Resend, seems like the earlier patch doesn't quite actually work as
>> advertised; -Wformat-security needs -Wformat enabled as well.
>> ---
>> [PATCH] Kbuild: Enable the gcc flag -Wformat-security
>
> We need to sort out the ~150 warnings you see in your
> allyesconfig build before applying this one.
> We try to avoid applying patches that increases the warning count
> without some effort done to fix it first.
>
> So let see what the other patch end up with.
>

Fine with me, the other patch needs to cook a bit first tho ;-)

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
