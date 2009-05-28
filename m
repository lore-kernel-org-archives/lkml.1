Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZE1WRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZE1WRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZE1WRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:17:04 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:54081 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZE1WRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dcilariCoWAexDLHAMqUQvR8uqXr5XCVmALOb1eRYXjho2LCuZ9bsddJJhHtRVKsdm
         8MgfR8domOdT9cTTz627HJwH+61f5sBBEUzZbxuGvLO0GxV5fgeFySUxe7EhHasrxoe9
         SRwtqMn7snlI5/rZMfj9UNcRZLkK1muWFBACM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905280929190.27708@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>
	 <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com>
	 <20090526205414.GA26016@kroah.com>
	 <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>
	 <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com>
	 <alpine.DEB.2.00.0905262231210.27902@gandalf.stny.rr.com>
	 <1243403437.3118.10.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0905271418290.17378@gandalf.stny.rr.com>
	 <20090527191310.GA466@kroah.com>
	 <alpine.DEB.2.00.0905280929190.27708@gandalf.stny.rr.com>
Date: Fri, 29 May 2009 07:17:01 +0900
Message-ID: <49b7c2350905281517k4b518c9of6e991f50571d427@mail.gmail.com>
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to 
	mount debugfs filesystem.
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <greg@kroah.com>, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 10:45 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 27 May 2009, Greg KH wrote:
>> > > >
>> > > > ( Note: it is more common to mount at /sys/kernel/debug, but for
>> > > >   simplicity this document will use /debug)
>> > > > ===
>
>> >
>> > I really don't want to do that. Then I would need to show
>> >
>> >  # echo function_graph > /sys/kernel/debug/current_trace
>> >
>> > Which I really do not like. I state that the common place to mount it is
>> > in /sys/kernel/debug, But my examples are much easier to understand if
>> > I just do: # echo function_graph > /debug/current_trace
>>
>> It's not just the "common" place, it is the DOCUMENTED PLACE.
>
> I can change the wording to be "documented" or "distro mounted".
>
>>
>> I'm sorry you have to type a long path, perhaps you wish to invest in a
>> tab key for auto-completion :)
>>
>> Again, distros already mount debugfs at this location, please don't
>> confuse people just because you are annoyed at the length of the path.
>
> Have you found which packages do that?
>
> The point is that the document is more interested in showing the files
> that are being used, and if I add /sys/kernel/debug/ in front of every
> file, that just distracts from the eye. As stated:
>
>  "but for simplicity this document will use /debug"
>
> I'll update ftrace.txt to explain it better.
Thank you for the decision to update  debufs filesystem realted contents.
>
> Something like:
>
> =====
> Debugfs is mounted by some packages at /sys/kernel/debugfs. If it is not
> you can mount it by adding
>
>  debugfs   /sys/kernel/debug  debugfs   defaults   0   0
>
> to your /etc/fstab, or by manually mounting it:
>
>  # mount -t debugfs nodev /sys/kernel/debugfs
>
> For simplicity, this document will assume that you also added the
> following symbolic link:
>
>  # ln -s /sys/kernel/debugfs /debug
> =====
About typo in the above statements.
/sys/kernel/debugfs --> /sys/kenrel/debug
Default directory of debugfs filesystem is /sys/kernel/debug/ as you know.

>
> Then I can keep the document simplistic and still have the "DOCUMENTED"
> locating specified.
>
> -- Steve
>
>



-- 
Regards,
GeunSik Lim ( SAMSUNG ELECTRONICS)
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
