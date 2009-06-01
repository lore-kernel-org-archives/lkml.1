Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbZFAAOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbZFAAOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZFAAN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:13:58 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:46209 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZFAAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pGEHCGJNPrtXo8eHRO9LIYwPJQXASF/Iu6U+oVhuafFiv54GTIDw4hFuqy0f00uL3A
         lcrGb6Pu1on0kn/A80ncNbGxY58lULHg6l/2XD9VMBRl4W7NtC3IpkhBAtQenmkYuEHQ
         pWvT3gFcf152qafH+2Y8aZjjhX6ndmpxZ+eUo=
MIME-Version: 1.0
In-Reply-To: <1243782861.6592.415.camel@desktop>
References: <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
	 <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
	 <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
	 <1243781365-26814-4-git-send-email-tom.leiming@gmail.com>
	 <1243781365-26814-5-git-send-email-tom.leiming@gmail.com>
	 <1243782861.6592.415.camel@desktop>
Date: Mon, 1 Jun 2009 08:14:00 +0800
Message-ID: <d82e647a0905311714k1d9634a6gc9d2924956e3e1dd@mail.gmail.com>
Subject: Re: [PATCH 4/8] kernel:lockdep:implement find_usage_*wards by BFS
From: Ming Lei <tom.leiming@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/31 Daniel Walker <dwalker@fifo99.com>:
> On Sun, 2009-05-31 at 22:49 +0800, tom.leiming@gmail.com wrote:
>> -static inline int __bfs_forward(struct lock_list *src_entry,
>> +static inline int __bfs_forwards(struct lock_list *src_entry,
>
> Your patchset seems a bit young still .. For instance, adding an "s" in
> the above line, that's just flux that really shouldn't be there.. I was
> reviewing your patches but I stopped because it just looks like you need
> to organize them better. I wonder for one, if they bisect or if they
> pass checkpatch .. Your code also seems to have a lot of other little

Only No 3. patch has a checkpatch error, so we can continue to review them
now,  can't we?

> cleanup type issues..
>
> Daniel
>
>



-- 
Lei Ming
