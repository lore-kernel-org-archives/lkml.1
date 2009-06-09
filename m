Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZFIXgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZFIXgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZFIXgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:36:00 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:50181 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZFIXgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=psBZBpMpBdpbGabbnoVd3ItyfPgzUSM2+OLqlMd5p3G7p8zHn4WmhrF78z4BZxMFkV
         fReYb08n+a/PXA/Ly6n3BgoJixLkqmM8uEdpIx0/xyxlRMGTp9/eEvvsQYFRLyTC+8o3
         qKeCj5GmMlNiNIThz4cIqBXcwmdxhmnvoRXLo=
MIME-Version: 1.0
In-Reply-To: <20090609161945.811cc01f.akpm@linux-foundation.org>
References: <20090603142801.GC21646@beaver.vrungel.ru> <4A26EB18.6060907@zytor.com> 
	<20090609161945.811cc01f.akpm@linux-foundation.org>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Tue, 9 Jun 2009 16:30:31 -0700
X-Google-Sender-Auth: 5e2d32289e2eeceb
Message-ID: <2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com>
Subject: Re: devpts mounts too slowly
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, renton@renton.name,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 9, 2009 at 4:19 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Wed, 03 Jun 2009 14:28:56 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>> Alexey Vlasov wrote:
>> > Hi.
>> >
>> > In comparison with bind/proc mounting it takes a lot more time mounting
>> > devpts. Is it possible to somehow accelerate the process? Now there are
>> > about 5k devpts mounting, it already took 20 minutes, further will take
>> > even more time.
>> >
>> > # time mount -n -i -t devpts none /home/staff/.server-1/dev/pts
>> > real    0m0.295s
>> > user    0m0.000s
>> > sys     0m0.288s
>> >
>>
>> A profile would be handy here.  There is no sensible reason for this to
>> that 0.3 seconds.  This might be RCU-epoch related?
>>
>
> It seems OK here.
>
> akpm2:/home/akpm/xx# time mount -n -i -t devpts none /tmp/pts
> mount -n -i -t devpts none /tmp/pts  0.00s user 0.00s system 0% cpu 0.002 total

I read the Original Post as that test being performed with 5k /dev/pts
already mounted.
