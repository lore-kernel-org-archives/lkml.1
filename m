Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZHKMip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZHKMip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZHKMio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:38:44 -0400
Received: from main.gmane.org ([80.91.229.2]:45985 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbZHKMin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:38:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: case-duplicated filenames
Date: Tue, 11 Aug 2009 13:38:29 +0100
Message-ID: <yw1xy6pq7cfu.fsf@unicorn.mansr.com>
References: <a9c5028086c7f5f0e245853b9065e187.squirrel@ubb.ca> <4A80D5DF.3090402@davidnewall.com> <4A80D6D4.3080005@ubb.ca> <9b2b86520908110243r3d527b3n518fe4d3714a7bde@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
Cancel-Lock: sha1:JUA7kWszBff/KWdZVa5vcPuXdhU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins <sourcejedi.lkml@googlemail.com> writes:

> On 8/11/09, Tony Mantler <nicoya@ubb.ca> wrote:
>> David Newall wrote:
>>> Tony Mantler wrote:
>>>> A co-worker reminded me this afternoon that the linux source tree does
>>>> not
>>>> get along well with case-insensitive filesystems. Ever the curious and
>>>> bored sort, and in the middle of an sqlite bender, I decided to cook up a
>>>> quick script to find exactly what files those are.
>>>>
>>>
>>> Such an extravagant process: you're just being silly.
>>
>> Well I did say I was bored. ;)
>
> Performance aside, it's a one-liner in shell* ;).
>
> find | sort | uniq -ic | grep -v " 1 "
>
> [*]  Posix compliance not guaranteed.  I don't know how standard uniq -i is.

It's not standard.  You're also assuming case-insensitive sort.  Using
sort -f increases the chances of this doing what you want, but it
still depends on the locale settings.

-- 
Måns Rullgård
mans@mansr.com

