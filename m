Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZGMVv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZGMVv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbZGMVvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:51:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47224 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbZGMVvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Sq7rGfAEin68m6VxYqtKP4IqI5q7Xl+XsWRJP3O6mHbw8Pf7fGZudoUkYZxlIGy/Xx
         is7Q/g63SC9XotlRJZIVdH8jmryMUyqevRyNlcGiDWaJ19gy5xSmI06uh9D21JsttQgg
         eW8iOJVVlA4Rpjb7StjR/uRI7xZDsmLln4OYM=
Message-ID: <4A5BAC77.9010503@gmail.com>
Date: Mon, 13 Jul 2009 23:51:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>	 <1247521235.7178.1.camel@johannes.local>  <4A5BAABF.9020708@gmail.com> <1247521789.7178.2.camel@johannes.local>
In-Reply-To: <1247521789.7178.2.camel@johannes.local>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 11:49 PM, Johannes Berg wrote:
> On Mon, 2009-07-13 at 23:44 +0200, Jiri Slaby wrote:
> 
>>> I've had local hacks
>>> many times to make sparse aware of mutexes, is there a reason they are
>>> not annotated with __acquire(s)/__release(s) like spinlocks etc.?
>>
>> Mutexes are often locked/unlocked interprocedural which I think sparse
>> can't do much about.
> 
> Well, you annotate those functions too, of course.

Sorry, I don't understand. What functions I annotate?
