Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbZHKLxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbZHKLxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZHKLxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:53:39 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52310 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZHKLxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S8hDwGb5CSrZeo5SrVZ2R6L40i1CaXWR0VCVIS5AKFQughS39PjMOHb2ayN1iOKz31
         RfRga+eKP5txr4BD5aFE8FWTtbP83zroLBjc3xEfqbMg4Ioxn+6c2TS/aA7YGoAlccjC
         nXHNaUWg3zbBZwNl4EYfBs3GyMyXnvGcjUwck=
MIME-Version: 1.0
In-Reply-To: <4A80D6D4.3080005@ubb.ca>
References: <a9c5028086c7f5f0e245853b9065e187.squirrel@ubb.ca>
	 <4A80D5DF.3090402@davidnewall.com> <4A80D6D4.3080005@ubb.ca>
Date: Tue, 11 Aug 2009 10:43:40 +0100
Message-ID: <9b2b86520908110243r3d527b3n518fe4d3714a7bde@mail.gmail.com>
Subject: Re: case-duplicated filenames
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Tony Mantler <nicoya@ubb.ca>
Cc: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/09, Tony Mantler <nicoya@ubb.ca> wrote:
> David Newall wrote:
>> Tony Mantler wrote:
>>> A co-worker reminded me this afternoon that the linux source tree does
>>> not
>>> get along well with case-insensitive filesystems. Ever the curious and
>>> bored sort, and in the middle of an sqlite bender, I decided to cook up a
>>> quick script to find exactly what files those are.
>>>
>>
>> Such an extravagant process: you're just being silly.
>
> Well I did say I was bored. ;)

Performance aside, it's a one-liner in shell* ;).

find | sort | uniq -ic | grep -v " 1 "

Alan

[*]  Posix compliance not guaranteed.  I don't know how standard uniq -i is.
