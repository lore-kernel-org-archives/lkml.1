Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0BCQkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:40:25 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46096 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab0BCQkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:40:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Zmf50AZhrSTJ538VzXEnUZ/g3O01cmJzqqlVc0yS+UaLtOVH9jrP37GECfu4jfZzfP
         6xIXFeJV6LptkMe7TguBak2wUglN12QUcuLFM/7CMzBCeqARb8WAKUdAsqIYi5hZrFVk
         Mpw2lEBrbdzVl7XmmzUppWg8ef39GfPs7t45w=
MIME-Version: 1.0
In-Reply-To: <1265214665.24386.3.camel@gandalf.stny.rr.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-3-git-send-email-dvhltc@us.ibm.com>
	 <520f0cf11002030807t48678b82ye56624840e6f9ce3@mail.gmail.com>
	 <1265214665.24386.3.camel@gandalf.stny.rr.com>
Date: Wed, 3 Feb 2010 17:40:17 +0100
X-Google-Sender-Auth: 1024577b07f9d768
Message-ID: <520f0cf11002030840j3b1ab71eu5a6a3c918458f845@mail.gmail.com>
Subject: Re: [PATCH 2/3] trace-cmd: fix printf compile warnings
From: John Kacur <jkacur@redhat.com>
To: rostedt@goodmis.org
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 3, 2010 at 5:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2010-02-03 at 17:07 +0100, John Kacur wrote:
>> On Mon, Feb 1, 2010 at 5:50 PM, Darren Hart <dvhltc@us.ibm.com> wrote:
>> > Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
>> > ---
>> >  trace-read.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/trace-read.c b/trace-read.c
>> > index a04c85b..5befaba 100644
>> > --- a/trace-read.c
>> > +++ b/trace-read.c
>> > @@ -216,7 +216,7 @@ static void read_rest(void)
>> >                r = read(input_fd, buf, BUFSIZ);
>> >                if (r > 0) {
>> >                        buf[r] = 0;
>> > -                       printf(buf);
>> > +                       printf("%s", buf);
>> >                }
>> >        } while (r > 0);
>> >  }
>> > --
>> > 1.6.3.3
>> >
>>
>> Oh! Obviously correct, thanks Darren.
>
> Of the three patches, I think this is the only one that is correct ;-)
>

Ah, you're a hard taskmaster! Are you going to push it to your repo
for us then pls?
