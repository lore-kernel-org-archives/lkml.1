Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbZJSQQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbZJSQQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 12:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbZJSQQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 12:16:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:44138 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbZJSQQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 12:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZhXnZCaIJSXEObjWxnqH3XogHzfePlV0Yyc2IzIPBbiHGslMzZ8Fb2Gz1wjdT89Nif
         eW2nyG8Pl2JfczwSwf4SY3GqkBp+DPRPD0cKFLr3mI5HQ5+87Cr9IagJHfH6yL8O/dSd
         L5bSaRcyRcXuKpmTfelOcx91dDH9NbSyMAf+Q=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0910191658260.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-6-git-send-email-felipe.contreras@gmail.com>
	 <alpine.LSU.2.00.0910191616290.8582@wotan.suse.de>
	 <94a0d4530910190757y139c7e20xe6a58f0cbf13a79d@mail.gmail.com>
	 <alpine.LSU.2.00.0910191658260.8582@wotan.suse.de>
Date: Mon, 19 Oct 2009 19:16:07 +0300
Message-ID: <94a0d4530910190916t2bdd9ecl59a3cfc0cc732852@mail.gmail.com>
Subject: Re: [PATCH 5/7] acpi: fix a bunch of style issues on 'actypes.h'
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 6:03 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 19 Oct 2009, Felipe Contreras wrote:
>
>> > I have never been in favor of merging whitespace-only patches (in a
>> > sense that the sole purpose of them being to change whitespaces, but
>> > no else value added).
>> If somebody tries to send a patch for that file that doesn't fix the
>> white-space, checkpatch will complain, and people will complain that
>> checkpatch complains, which is precisely what happened,
>
> Oh, well ... checkpatch warning about this is somewhat controversial. My
> preferred way would be that it warns about whitespace only if there are
> also some other (non-whitespace) changes.

Huh? I think we are talking about different things. See the next comment.

>> and I was requested to write this patch by Daniel Walker (final mail
>> wasn't on the ml):
>>
>> http://lkml.org/lkml/2009/9/14/183
>
> This is something slightly different -- he asks you to fixup whitespace
> issue in the code you are newly introducing, right?

No, did you read the thread?

This was my patch:
-#define ACPI_MIN(a,b)                   (((a)<(b))?(a):(b))
-#define ACPI_MAX(a,b)                   (((a)>(b))?(a):(b))
+#define ACPI_MIN(a,b)                   min(a, b)
+#define ACPI_MAX(a,b)                   max(a, b)

Checkpatch complains, even though my changes are ok. So that's what I
mean, if somebody wants to do a similar patch in the future so that
checkpatch doesn't complain; they would have to fix the white-spaces
again.

Or checkpatch should be fixed.

>> > And after today's discussion on kernel summit on this topic, I wouldn't
>> > expect any maintainer to merge it, sorry :)
>> What are you talking about?
>
> Seems like many kernel maintainers are just tired of
> 'whitespace-cleanup-only' patches that bring no real added value
> otherwise.

Hm, I wonder what would happen to the current badly formatted code.
Stay there forever?

-- 
Felipe Contreras
