Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYIPLn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYIPLn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 07:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYIPLnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 07:43:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:13867 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYIPLnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 07:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=EW+kPXa0LmrXJb6SmJYUq/2Pqsc8x/JljCFrEwxIlg9hfI6MuFoG5uC1X9zQsqJCrN
         vVrhazElBxrINpR5j9K7SVDRiWRmwGtPXC70deBPEyeDpDfSSim3IoiONzHyuxzdeSUK
         ju1lwOK+PlwYt/n9mRMbXwHvBweH5HAWoCREs=
Date: Tue, 16 Sep 2008 11:43:05 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
Message-ID: <20080916114305.GB10965@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916104811.GC7397@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-09-2008 12:48, Adrian Bunk wrote:
> On Tue, Sep 16, 2008 at 12:40:14PM +0300, Adrian Bunk wrote:
>> On Tue, Sep 16, 2008 at 11:18:08AM +0200, Thomas Bogendoerfer wrote:
>>> On Tue, Sep 16, 2008 at 11:39:34AM +0300, Adrian Bunk wrote:
>>>> On Mon, Sep 15, 2008 at 03:11:25PM -0700, David Miller wrote:
>>>>> From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
>>>>> Date: Mon, 15 Sep 2008 23:53:08 +0200
>>>>>
>>>>>> On Mon, Sep 15, 2008 at 02:14:42PM -0700, David Miller wrote:
>>>>>>> Most of those changes were complete and utter CRAP.
>>>>>> thank you, but the fix I've sent (de2104x) isn't crap. The bug breaks the 
>>>>>> current debian-installer for Cobalt Qube1, when it tries to get an
>>>>>> IP address via dhcp. 
>>>>> And why is this bug that has been there for YEARS is appropriate
>>>>> to fix outside of the merge window?
>>>>> ...
>>>> Such a fix is even suitable for -stable.
>>> that was my feeling as well, but if David wants to see it in the next
>>> merge window, it's his decision. It's not a important fix as the user
>>> base is obviuosly pretty small. And I didn't know about that bug, when
>>> the merge windows was open, so I couldn't fix it "in time".
>> And if it goes in during the next merge window it can immediately go 
>> into 2.6.27.1 (and even 2.6.26.y if it's still maintained), since the 
>> fix fulfills Documentation/stable_kernel_rules.txt .
>>
>> That doesn't make sense.
> 
> Note that my emails are not meant against David personally - he just 
> seems to have gotten from pushing too much to pushing too few, with
> such illogical results.
> 
> cu
> Adrian

Probably he can read.

Jarek P.

PS:

On 04-09-2008 01:24, Linus Torvalds wrote:
> 
> On Wed, 3 Sep 2008, Linus Torvalds wrote:
>> What's so hard to understand about this?
> 
> Here's a simple rule of thumb:
>  - if it's not on the regression list
>  - if it's not a reported security hole
>  - if it's not on the reported oopses list
> then why are people sending it to me?
> 
> IOW, if it's just another random improvement, and you send it to me 
> outside of the merge window, then what is the point of the merge window? 
> 
> 		Linus
