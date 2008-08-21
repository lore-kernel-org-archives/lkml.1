Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYHUR5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYHUR5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYHUR5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:57:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:11698 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYHUR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rdk86chw1/zyVdk8P4qJ3vbRbHmjyBYSDmPd9TWu93Hyc4ZZKkG+2G/yzX/ddu07zl
         Ugn1CLkXUH/4fNWN221PYapYZf+OshFb7w/bfx+v3OdKVUyLG5eaQ2kLN8Xexe9vt/hI
         EvuGK9XbmvdtAZdre7H5p9LqbBGcYaxnk8Frs=
Message-ID: <86802c440808211057j41e2b0c8jcd0817ca047962d0@mail.gmail.com>
Date: Thu, 21 Aug 2008 10:57:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>, "Vivek Goyal" <vgoyal@redhat.com>,
       "Bill Fink" <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <198958.27259.qm@web82105.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <198958.27259.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 9:53 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> > I will try to provide the entire output tonight or tomorrow.  It will be
>> > difficult, though:  it looks like I have to try to fit the info from about
>> > 60 of the printk's in your patch onto the 80x25 VGA screen, and still
>> > make it understandable enough to be useful.
>> >
>>
>> with hpet=disable?
>
> Oh, well that's easy.  (See below.)  I assumed you needed the data for a
> hanging kernel, not one with the workaround enabled.
>
> I can still try to provide the output of the printk's in your patch later,
> in that would have any value.  Here is 'dmesg' for a recent kernel with
> "hpet=disable":

insert_resource/request_resource works well

can you verify if hpet work on old kernel?

cat /proc/timers*

YH
