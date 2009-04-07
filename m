Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbZDGFyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbZDGFyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZDGFyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:54:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46151 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZDGFyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=keweKt7Qvd6K/fU3NSjaQ+GmqGKNFIpTT1YgZNB7rQpwj+MvnIg7h3kK6qHHdjstHG
         emLpz4aOr8mR49ZnNwwoHzexf9dj0zLywzGJI/obm8B+4C0L9pNV9R1KAsIj+TkLoCxw
         FpEdEvjoNBz2DRAD2NtA+hXAO3W1fdQVJXIT8=
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<200904061217.31134.mb@bu3sch.de> <87tz52xepy.fsf@litku.valot.fi>
	<200904061251.10965.helmut.schaa@gmail.com>
	<da94abde0904060405k280b3094jc20d0f7a4e6e759d@mail.gmail.com>
	<87iqlhdd3z.fsf@litku.valot.fi> <20090406180042.GD10842@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 07 Apr 2009 08:54:35 +0300
In-Reply-To: <20090406180042.GD10842@tuxdriver.com> (John W. Linville's message of "Mon\, 6 Apr 2009 14\:00\:42 -0400")
Message-ID: <87fxglhuuc.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"John W. Linville" <linville@tuxdriver.com> writes:

> On Mon, Apr 06, 2009 at 06:18:56PM +0300, Kalle Valo wrote:
>
>> When I'm able to implement the proper fix, I think it should first have
>> proper testing in wireles-testing before pushing it to mainline. So
>> maybe the proper fix is 2.6.31 material, just to be on the safe side
>> here.
>> 
>> John, what do you think?
>
> It depends on what the proper fix looks like, but basically anything
> posted in the last week and thereafter is already 2.6.31 material
> unless it is a specific bug fix for what is already in Linus' kernel.

Ok, that settles it then. Because this bug has been in mac80211 for ages
we can wait for 2.6.31.

But do you take Michael's patch[1] for disabling the "beacon loss"
message for 2.6.30? I think we should have it in 2.6.30, otherwise we
will get quite a lot of bug reports. Do you want me to resend it?

[1] http://marc.info/?l=linux-kernel&m=123892431619630&w=2

-- 
Kalle Valo
