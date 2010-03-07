Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0CGBFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 20:05:43 -0500
Received: from mail-qy0-f199.google.com ([209.85.221.199]:33848 "EHLO
	mail-qy0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab0CGBFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 20:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o71NMk2GtAHSWzYLpZ7jpCxsiWjlYS5OhM6UCDMuO37rA/XNtULO+GRl5fEJRg5UYN
         tgIgHUjfNStaCEcya+65IWljK0k83ZjzkizfokKtqDxKJwEV3T3on6y8a5AnfQDyCSTi
         vfGnYHhYvlXiZovbqdze/tWo3bFewPlv65ihc=
MIME-Version: 1.0
In-Reply-To: <20100306104131.GV28972@buzzloop.caiaq.de>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com> 
	<19346.6765.457769.167118@pilspetsen.it.uu.se> <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com> 
	<20100306104131.GV28972@buzzloop.caiaq.de>
From: dave b <db.pub.mail@gmail.com>
Date: Sun, 7 Mar 2010 12:05:21 +1100
Message-ID: <25ae2d691003061705l5fc0bca7n4a07f558a0c410cf@mail.gmail.com>
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
To: Daniel Mack <daniel@caiaq.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok... however how should one test the memory of an arm machine? ...
memtest is only for x86. *I am referring to the kernel memtest and not
memtest86.


On 6 March 2010 21:41, Daniel Mack <daniel@caiaq.de> wrote:
> On Sat, Mar 06, 2010 at 09:24:49PM +1100, dave b wrote:
>> On 6 March 2010 20:03, Mikael Pettersson <mikpe@it.uu.se> wrote:
>> > dave b writes:
>> >  > Hi have now successfully built a 2.6.33 kernel on a linkstation pro
>> >  > v2. This is an arm device. It is currently running debianÂ  lenny
>> >  > armel.
>> >  >
>> >  >
>> >  > I compiledÂ  (make) zImage, then did a make modules which failed on the
>> >  > first two rounds of compiling the modules -
>> >  >
>> >  > "fs/afs/super.c: In function â€˜afs_test_superâ€™:
>> >  > fs/afs/super.c:278: internal compiler error: Segmentation fault
>> >  > Please submit a full bug report,
>> >  > with preprocessed source if appropriate.
>> >  > See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions."
>> >  > This was the error encountered on the attempt at compiling the
>> >  > modules.
>> >  >
>> >  > "crypto/gcm.c: In function â€˜crypto_gcm_setauthsizeâ€™:
>> >  > crypto/gcm.c:152: internal compiler error: Segmentation fault
>> >  > Please submit a full bug report,
>> >  > with preprocessed source if appropriate.
>> >  > See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions.
>> >  > make[1]: *** [crypto/gcm.o] Error 1"
>> >  > This was the error the on the second attempt at compiling the modules.
>> >  >
>> >  > The 3rd attempt at building the modules was successful...
>
> Whenever I had comparable problems, it was _always_ faulty RAM on my
> local machine, and I'm very sure you're seeing a similar. _If_ gcc
> crashes, it will always do that for the same input.
>
> Daniel
>
>
