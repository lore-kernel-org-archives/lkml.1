Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZG0JHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZG0JHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZG0JHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:07:03 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:46935 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZG0JHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=My34vHMEWlLlvR3YHpLJeVYNqGXnDdR1ivUKNflde1hfWDqjRI8Bd68kRUsMttTu81
         V7PY2HCAgrX1qP9cObDKPcF6DWh0IhpNbOFv+x3xBQGnqdXovaA5lm0rYBi5k5VfYT3B
         Eh50NZ4Fd2bNkxzRa5DfiL3h/3MwEEwBd8FjU=
MIME-Version: 1.0
In-Reply-To: <1248675700.6987.1416.camel@twins>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.c9D.3HObKB@chimera> <1248675700.6987.1416.camel@twins>
Date: Mon, 27 Jul 2009 10:07:00 +0100
Message-ID: <6278d2220907270207g7ff93fd1kdf59e32f139269d3@mail.gmail.com>
Subject: Re: [Bug #13730] hitting lockdep limits...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 7:21 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.30.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13730
>> Subject               : hitting lockdep limits...
>> Submitter     : Daniel J Blueman <daniel.blueman@gmail.com>
>> Date          : 2009-07-05 18:19 (22 days old)
>> References    : http://marc.info/?l=linux-kernel&m=124681799023782&w=4
>>
>
>
> Is this still a problem after?
>
> commit b0a5b83ee0fce9dbf8ff5fe1f8c9ae7dfafe458c
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Jun 16 16:11:14 2009 +0200
>
>    dma-debug: Put all hash-chain locks into the same lock class

Using the same .config and use profile, I haven't seen this in
2.6.31-rc4, thus this can be closed. I've updated the kernel bugzilla
entry also.
-- 
Daniel J Blueman
