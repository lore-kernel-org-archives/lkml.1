Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYJ0XMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYJ0XMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJ0XMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:12:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:22306 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYJ0XMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UtnEiBCpn28UrEk+f1ULTkwHJUCudvr+OAmjhXH+ExvcOmXke9Y25Lr5OPISY6xrTM
         BFrt7LXEMV/OuInrR3jnUuHPIPBmi4O/Hg3gVDa9YS5+2BDifTZobn+8IPc220oLpjuj
         fMzVE/0TXajhOY5MTAtPimS8jeVO1DuKwtfYQ=
Message-ID: <1ba2fa240810271612g72bb2b08p6ebab9f6f02f5b98@mail.gmail.com>
Date: Tue, 28 Oct 2008 01:12:30 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Soeren Sonnenburg" <kernel@nn7.de>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200810272350.29429.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <20081027222852.GA3907@localhost.aei.mpg.de>
	 <1ba2fa240810271540t1d1ba5c9me60f86dec357f53e@mail.gmail.com>
	 <200810272350.29429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

h

On Tue, Oct 28, 2008 at 12:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 27 of October 2008, Tomas Winkler wrote:
>> On Tue, Oct 28, 2008 at 12:28 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
>> > On Mon 27.Oct'08 at 23:07:00 +0200, Tomas Winkler wrote:
>> >>[...]
>> >>
>> >> Can someone try this one (it might be space broken I've just pasted
>> >> that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
>> >> (latest linux-2.6.git)
>> >
>> >
>> > Yes, this one also works for me (I applied it manually).
>> Good, this was actually part of some older and bigger patch I wasn't
>> aware it has this affect. It has some millage in iwl5000 branch.
>> RFKIll went through some changes in the mainline so it wasn't merged yet.
>
> Are you going to push this patch upstream now?  It's quite important to get
> this resume regression fixed ASAP.

Definitely I would post it to wireless and stable.  I would like to
hear from Harvey, though if this is somehow related to b43 as well. I
will it give some more testing tomorrow morning I don't have any HW
right now and need to suspend to bed :)

Again, sorry for troubles.
Tomas
