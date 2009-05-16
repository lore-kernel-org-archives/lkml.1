Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZEPGkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZEPGkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 02:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZEPGke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 02:40:34 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:50979 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZEPGkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 02:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I7NxGwmygEsYhnpaqXJuwBESwTgr88dScsfzB6kDEcKo+TQjPzL75hfs4j12LFpz0V
         3VW+Mi9YWuYO58BTC18H+9nm6fHsMPnSGTVz5TeJ8w5SQZycCgqH9AoR9jm6WV6M7o0U
         aHGEScojPTlX6As5omNEUTvB+IbOe4f0MY3K8=
MIME-Version: 1.0
In-Reply-To: <84144f020905152340v85b72cdr22fe4920bebae510@mail.gmail.com>
References: <20090515195520.GA7715@damson.getinternet.no>
	 <84144f020905152340v85b72cdr22fe4920bebae510@mail.gmail.com>
Date: Sat, 16 May 2009 09:40:32 +0300
X-Google-Sender-Auth: d6f7a3c0a5d53a6d
Message-ID: <84144f020905152340j40701892v65124740a80c7cf6@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: make bitfield annotations be valid C
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding viro to cc)

On Sat, May 16, 2009 at 9:40 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Fri, May 15, 2009 at 10:55 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> From bb8926742d87da95aeb373bc2d4b35a554c5001b Mon Sep 17 00:00:00 2001
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Fri, 15 May 2009 21:34:36 +0200
>> Subject: [PATCH] kmemcheck: make bitfield annotations be valid C
>>
>> According to Al Viro, the syntax we were using (putting #ifdef inside
>> macro arguments) was not valid C. He also suggested using begin/end
>> markers instead, which is what we do now.
>>
>> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
>> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
> Al, are you okay with this?
>
