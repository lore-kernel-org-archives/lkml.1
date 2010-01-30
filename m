Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665Ab0A3UuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0A3UuE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521Ab0A3UuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:50:00 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:51335 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0A3Ut7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l2gSQffvo7B10lrHZdBBQ3pFUuPq4RJlSgksim5akznl+o75l2nquW+vaPG1raCm01
         q/51Xo5eAHjvxXQyxUehp4N1heqzZOLPJVlO0QjU+QufV1wCxtxAtsTTTv+28V9COJWW
         61LAmviWI4hiWl2ob3bae1twgN+mI8a5HAdvs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001301153390.4206@localhost.localdomain>
References: <1264871899.1533.6.camel@localhost.localdomain>
	 <alpine.LFD.2.00.1001300929260.4206@localhost.localdomain>
	 <201001302050.11897.johannes.hirte@fem.tu-ilmenau.de>
	 <alpine.LFD.2.00.1001301153390.4206@localhost.localdomain>
Date: Sat, 30 Jan 2010 21:49:57 +0100
Message-ID: <520f0cf11001301249l6b07473cp938e67f403fbf0cf@mail.gmail.com>
Subject: Re: Radeon KMS regression still present in 2.6.33-rc6
From: John Kacur <jkacur@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Dave Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 8:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 30 Jan 2010, Johannes Hirte wrote:
>>
>> This is caused by commit 42590a75019a50012f25a962246498dead42843
>>
>> Fix is already posted:
>>
>> http://marc.info/?l=linux-kernel&m=126428141429200&w=2
>
> Goodie. Kevin, can you test the patch from FUJITA Tomonori in that thread
> ("http://marc.info/?l=linux-kernel&m=126439631307219&w=2" to be exact).
>

The little hunk of code that Kevin posted is also the source of a new
warning in -rc6,
which is easily fixed. (following up with a patch)

Assuming the patch in that link fixes the problem, the order of the
check of the aper_size in
radeon_agp_init appears incorrect to me. Also following up with a patch.

John Kacur
