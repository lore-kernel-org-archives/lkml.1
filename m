Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZJ2Vwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZJ2Vwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZJ2Vwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:52:31 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57345 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbZJ2Vwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:52:30 -0400
X-Greylist: delayed 1637 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2009 17:52:30 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Ryqs96glaPaT/0z5eQ7XSh/lJrUJFR4LMikZ4GjHaAtICHr3WBtbyG5lH7x1IIa9O+
         m6DhxjXWvvNvF2JchmxcBXwHJZGt4TRzLq3fZcJ6NnuBzt6IVvgx+RMysZqPh7LMTCis
         8YIoKgyGYMt+2QA6pI9TtCAGy8LB1cnKgQHAY=
MIME-Version: 1.0
In-Reply-To: <20091029214241.GH18464@mit.edu>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
	 <20091016091558.GA10184@mit.edu>
	 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
	 <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
	 <20091029214241.GH18464@mit.edu>
Date: Thu, 29 Oct 2009 17:52:34 -0400
Message-ID: <f7848160910291452g58c9b6ecwd3c8671cd87b012b@mail.gmail.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
From: Parag Warudkar <parag.lkml@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Parag Warudkar <parag.lkml@gmail.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 5:42 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Oct 29, 2009 at 05:25:17PM -0400, Parag Warudkar wrote:
>> > Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> > Date:   Tue Oct 27 15:36:38 2009 +0530
>> >
>> >    ext4: discard preallocation during truncate
>> >
>> Just wanted to let you know that I have applied this patch and one
>> unclean shutdown later it seems to have not given me any trouble.
>>
>> I will continue testing it - hopefully I won't have to reformat  this
>> time ( every time I tested previously I ended up having weird issues
>> that I decided to get rid of by reformatting /).
>
> Cool!
>
> It looked like Avery Fisher had reported that had had tried patch
> didn't help him, and so I had put it in the category of "good patch,
> makes sense, but probably not the one that would solve this
> regression".  But if it works for you, I'll accelerate getting it to
> Linus.  Do let us know if you have any additional problems with this
> patch, please!
>

I have gone through 3 unclean shutdowns so far - this time on Ubuntu
Karmic Release, today's -git and this patch.
Nothing odd to report.

[ Goes and crashes it again - comes back clean! ]

Since literally all of my previous attempts always resulted in
problems - something seems to have improved although there is no way
to tell if this is going to last long or that if it was Aneesh's patch
alone that improved things as last time i tried this I ended up
reinstalling and I switched to Karmic from Jaunty and I did not test
mainline for few days.

Any rate, I will let everyone know if I see anything different.

Thanks
Parag
