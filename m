Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271Ab0ATJxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0ATJxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009Ab0ATJxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:53:20 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:56597 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0ATJxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:53:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TvNB4Q0s/kF38aUHwws0KcS9evaKkPChqI2aIlmqzMFnvVjSTysfZWRb+ggn0FrjnD
         G9P51tYqvV10gh5rk5WOMwsuA+NOnF/0CYawFcss/4Lt7b6TJYho7EH2kMbDUsy7Q4JO
         t7Ug5QmBNwqOjcC2GfGzVkh5CWPkDDItCiWM4=
MIME-Version: 1.0
In-Reply-To: <20100119165639.GC23161@linux-mips.org>
References: <20100118202414.GA4207@x200>
	 <20100119165639.GC23161@linux-mips.org>
Date: Wed, 20 Jan 2010 11:53:16 +0200
Message-ID: <b6fcc0a1001200153h6561d14ft61a9425719fb4203@mail.gmail.com>
Subject: Re: what's up with "make -j N" output?
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 6:56 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Mon, Jan 18, 2010 at 10:24:14PM +0200, Alexey Dobriyan wrote:
>
>> Script does effectively:
>>
>>       make -k -j5 &>1.log
>
> My automated builds effectively run a number of "make -j 1" builds in
> parallel so I get sane parsable and readable logs.

I do this too, still -j1 is waste of time if only one compile is running
for whatever reason.

> I don't think we give any guarantees for -j 2 or higher even though
> that would be highly desirable when things go wrong.

Meanwhile, bug dissapeared somewhere. :-\
