Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZKQAlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZKQAlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZKQAln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:41:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:2120 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZKQAln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:41:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Eywvy2yjh5SCtUfHknCMjVDIP0a7KlbWQ/O1Zzln47btWJeSkiUVWf6xJA+1EIMHXR
         /w6WOaVetPaR+2Ja69geyAgQUdF8WhqBKbRWiIb5DOj/DExVfX5IsbmqWqjWvrUkJ42G
         naXL5vZ+JNwjeWbWJe/a9LXE8ZtaDFmUYmLt8=
MIME-Version: 1.0
In-Reply-To: <43e72e890911161515q64ff527cyefd7d769f3c501b@mail.gmail.com>
References: <4ADE2F66.1070703@gmail.com>
	 <43e72e890911161515q64ff527cyefd7d769f3c501b@mail.gmail.com>
Date: Mon, 16 Nov 2009 19:41:47 -0500
Message-ID: <a44ae5cd0911161641n36d3c746pb69a9cac1eba1784@mail.gmail.com>
Subject: Re: 2.6.32-rc5-git1 -- BUG kmalloc-8192: Poison overwritten (ath9k 
	implicated)
From: Miles Lane <miles.lane@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 6:15 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Oct 20, 2009 at 1:45 PM, Miles Lane <miles.lane@gmail.com> wrote:
>> Let me know if you want my .config file.  I think this was triggered by
>> suspending my laptop.
>>
>> BUG kmalloc-8192: Poison overwritten
>
> Thanks for your report Miles.
>
> Are you using Linus' tree? Felix wrote some patches that got rid of
> the rate control private area which we kmalloc/kfree and at least one
> user reported that these patches fixed a memory leak. I'm curious if
> the same patches would resolve this issue.
>
> Only thing is these patches apply against wireless-testing and not
> 2.6.32. To test them you'd have to pull wireless-testing master to
> your tree and then apply the patches both before and after.
>
> Would you be up to try that?

Yes, definitely.  Thanks.  I will try to accomplish this and let you
know if I get stuck.

Miles
