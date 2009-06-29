Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZF2Bkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZF2Bkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZF2Bk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:40:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:30477 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZF2Bk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FmA55Sf1biyB6SpkNeMIf1sH7Yq9sMsKbDBjz19fi8rC8GdS/Dh3Qsr2k9u8YnU/m/
         Wi+IvczhDn//JIKKwYVbWAGRzji5Lv91dBRh5D1c/TZKa6vwEjE+jSCpjYfRDjLUF9vB
         ux1CgTpxXcryeCV4vWasqS1/0dB5BXNlOLa6w=
Message-ID: <4A481B88.30806@gmail.com>
Date: Mon, 29 Jun 2009 09:40:24 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Aviv Laufer <aviv.laufer@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, eric.miao@marvell.com,
       linux-kernel@vger.kernel.org
Subject: Re: Bug in tdo24m
References: <87972c700906230516n538ad959nbd4b1ea21943ffc2@mail.gmail.com> <1245761933.5987.20.camel@dax.rpnet.com>
In-Reply-To: <1245761933.5987.20.camel@dax.rpnet.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> Hi,
> 
> On Tue, 2009-06-23 at 15:16 +0300, Aviv Laufer wrote:
>> I have found a bug in tdo24m.c .
>> There is a call to kmalloc with the second param is sizeeof (flag)
>> instead of flag.
>> This cause  a crash.
> 
> Thats quite a nasty bug and its surprising its not been found before
> now! Can you resubmit the patch with description and most importantly a
> Signed-off-by line please (see Documentation/SubmittingPatches)?
> 

Ooops - this is embarrassing, yet I didn't find this causing any crash
by now,  tdo24m works just OK on my Littleton and thus hiding this bug
deeply.

Aviv,

Any update on this patch? I'd like to queue this ASAP.
