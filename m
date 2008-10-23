Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYJWWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYJWWEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYJWWEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:04:10 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:29420 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYJWWEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=YbRnZglJ9sCkcrk5TXW73dy+0jiT10lLY8Ir3DUACORAw/UqGJNfuyhf677HAY3VEi
         uUU/+y8QY5tWlrC/eD//cqIFJWsaummBsduoHfLXShaGg2WcUM0M8sBvPTytcR2nV1Fv
         aM4sCXF3/3Z1HddnXbcmOf9SIgsh0dQSn92uc=
Message-ID: <37219a840810231504r6a1d7c1eu5b2b05a6258a3597@mail.gmail.com>
Date: Thu, 23 Oct 2008 18:04:03 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mike Isely" <isely@pobox.com>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2 [USB REGRESSION] (USB -> D_STATE)]
Cc: "Greg KH" <greg@kroah.com>, "Alan Stern" <stern@rowland.harvard.edu>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Oliver Neukum" <oliver@neukum.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB list" <linux-usb@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810231451080.1475@cnc.isely.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
	 <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net>
	 <20081020172914.GA9624@kroah.com>
	 <Pine.LNX.4.64.0810231114320.1475@cnc.isely.net>
	 <20081023191543.GA10017@kroah.com>
	 <Pine.LNX.4.64.0810231451080.1475@cnc.isely.net>
X-Google-Sender-Auth: d09c09e24fd997b7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 3:54 PM, Mike Isely <isely@isely.net> wrote:
> On Thu, 23 Oct 2008, Greg KH wrote:
>
>> On Thu, Oct 23, 2008 at 11:27:11AM -0500, Mike Isely wrote:
>> > On Mon, 20 Oct 2008, Greg KH wrote:
>> >
>
>   [...]
>
>> > >
>> > > Will this patch be sent to the -stable group, to fix this regression in
>> > > 2.6.27?  Or should they take Alan's fix instead?
>> > >
>> >
>> > Greg:
>> >
>> > I didn't directly answer your question here because I had figured it was
>> > answered in a previous post on this thread, that Mike Krufky had already
>> > explicitly asked that it be queued (and added his Reviewed-By tag), and
>> > that I figured it best not to add yet more noise to an already noisy
>> > group.
>> >
>> > However now I see that this patch didn't get into 2.6.27.3.  It's a
>> > pretty important fix; without it the pvrusb2 driver is worse than
>> > useless (unless one adds initusbreset=0 as a module option).
>>
>> As we were discussing this on Monday, and the review cycle for 2.6.27.3
>> started last Saturday, it would have been pretty hard to get it into
>> 2.6.27.3 :)
>>
>> I need to see the patch in Linus's tree first, before it can go into any
>> stable release.  Is it in there yet?  If so, please send me the git
>> commit id and I'll queue it up for the next -stable round.
>>
>
> OK, I understand.
>
> As far as I know, Linus has not yet pulled the changes from Mauro (part
> of a larger set).  But that information is a few hours old.  I or Mike
> Krufky will let you know if/when one of us finds out.
>
> Thanks for following up.
>
>  -Mike

Mike,

Have you tested to confirm that FX2 firmware download without USB
reset still leaves the DTV firmware commands operable?

In other words, I'm not entirely sure about this fix.  If both Digital
and Analog still work with the patch included, then as far as I am
concerned, its fine for stable.

Greg, this is already in Linus' tree as of a few hours ago.  I had
already cherry-picked it and had planned to send it off to you after
testing it myself, but I probably wont get to that until Saturday or
Sunday.

If Mike Isely can confirm that Digital modes still work on the HVR1950
after a firmware download without an FX2 reset, then we don't need to
wait for my own testing.

The changeset in Linus tree is: c82732a42896364296599b0f73f01c5e3fd781ae

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>

Please wait on test results from Mike Isely or I confirming that
digital mode still works properly before queuing this one.

Thanks,

Mike Krufky
