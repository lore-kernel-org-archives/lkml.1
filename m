Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZLJThS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZLJThS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZLJThR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:37:17 -0500
Received: from mail-iw0-f193.google.com ([209.85.223.193]:35574 "EHLO
	mail-iw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbZLJThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:37:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XELrCEZqiiWfp751T56G3L7bN6Ecr3tXebNL1EHggCwEUfQzRzpoRuemF0y4MEhJjU
         rmqIkljZ4nR1dOLRpYnbc4M0iIHFXRXjUUX9H2Pq3JbnVAbLr19NvHp3MbR6UA817eBy
         +dNhFRhQUFPfKiZ5yui5SPmvC9MOV2Q11jq1E=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	 <1260459601.18520.26.camel@skunk>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
Date: Fri, 11 Dec 2009 05:37:21 +1000
Message-ID: <21d7e9970912101137k6f789e86x279aaf037732acb5@mail.gmail.com>
Subject: Re: [git pull] drm
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 4:42 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 10 Dec 2009, Maarten Maathuis wrote:
>>
>> You assume that Red Hat has full control over the project, which i
>> don't think is the case. The reason it isn't in staging yet (as far as
>> i know) is because of some questions over the copyright of some
>> (essential) microcode. Either the question needs to be answered, or it
>> has to be reverse engineered to the point that it's possible to
>> generate it.
>
> I think people are just making up excuses, as evidenced by the fact that
> you're quoting a different excuse than I've heard before.
>
> The fact is, if there are license questions, then Fedora had better not be
> distributing the code either. And they clearly are.

Alan mentioned this at KS, Fedora shipping something and RH taking
responsibility or something going upstream to you and then into multiple
other distros that aren't RH controlled are completely different questions
from the lawyers point of view. At the moment we cannot provide a Signed-off
version of nouveau, I don't think you are willing to accept stuff
without Signed-off-by's
unless something has changed recently.

>
> And don't tell me about "full control". There's absolutely full control
> over it being included or not.

While its not Red Hat's decision, we pay one of the nouveau developers
to work on it, but the project consists of a lot more than him, and RH generally
doesn't order upstreams to do stuff they aren't comfortable with.

If someone has time to take the nouveau patches and convert all the dubious
pieces of code to firmware loader interface and set it up so the main code
can be merged upstream and the firmware left to one side and someone
else can possibly redistribute the firmware then it might happen quicker.

Dave.
