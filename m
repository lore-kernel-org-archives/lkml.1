Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbZFVVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbZFVVTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZFVVS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:18:58 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:47592 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZFVVS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=GU0Uc5Di4ffNjs6M7WlQ2kgUosAEuyzBSwbcV1nyTXcHgdcP0QGA5A/+SUVheoFz3t
         1w7MKHEVLJPxcC7vWhxiGx9J1ZY8hKbyWSciVArrWruED4evoYxbAHygfY/+N+IWzEq3
         ztuLR8xzvBQ7DhGftLrvgS5LYfl3pIyXErbBw=
MIME-Version: 1.0
In-Reply-To: <20090622211540.GD24236@elf.ucw.cz>
References: <20090622180438.GG23972@bombadil.infradead.org> 
	<20090622204500.GB24236@elf.ucw.cz> <43e72e890906221411od16be51k2fc811dbf223ed9f@mail.gmail.com> 
	<20090622211540.GD24236@elf.ucw.cz>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 22 Jun 2009 14:18:39 -0700
X-Google-Sender-Auth: 808df05f06b594df
Message-ID: <43e72e890906221418i328df5c7v2f795235b41d0d97@mail.gmail.com>
Subject: Re: [PATCH] Documentation: add documentation summary for rc-series 
	and merge window
To: Pavel Machek <pavel@ucw.cz>
Cc: torvalds@linux-foundation.org, Greg KH <greg@kroah.com>,
       "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 2:15 PM, Pavel Machek<pavel@ucw.cz> wrote:
> On Mon 2009-06-22 14:11:45, Luis R. Rodriguez wrote:
>> On Mon, Jun 22, 2009 at 1:45 PM, Pavel Machek<pavel@ucw.cz> wrote:
>> > On Mon 2009-06-22 14:04:38, Luis R. Rodriguez wrote:
>> >> This is losely based on previous discussions on linux-kernel [1][2][3].
>> >> Lets also refer people reading the stable rules to
>> >> Documentation/development-process/.
>> >>
>> >> Also add the number of days it has taken between releases,
>> >> and provide the average for the last 10 releases: 86.0 days.
>> >>
>> >> [1] http://marc.info/?l=linux-kernel&m=122048427801324&w=2
>> >> [2] http://marc.info/?l=linux-netdev&m=122048757705315&w=2
>> >> [3] http://marc.info/?l=linux-kernel&m=124515657407679&w=2
>> >>
>> >> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> > NAK.
>> >
>> >> +2.0.2: RC-SERIES RULES
>> >> +
>> >> +This section summarizes what kind of patches are accepted before the merge
>> >> +window closes and after it closes. These patches are targeted for the kernel
>> >> +prior to its final release.
>> >> +
>> >> +The rc-series focus should really be to address regressions.
>> >> +
>> >> +2.0.2.0: RC-SERIES RULES PRIOR TO THE RC1 RELEASE
>> >> +
>> >> +These are the types of patches that will get accepted prior to a kernel rc1 release,
>> >> +during the merge window:
>> >> +
>> >> + - it must fix a regression
>> >> + - it must fix a security hole
>> >> + - it must fix a oops/kernel hang
>> >> +
>> >> +Non-intrusive bug fixes or small fixes will not be accepted. If the
>> >> patch in
>> >
>> > What? Prior to rc1, new features are accepted.
>>
>> For maintainers yes, for developers sending to the subsystem
>> maintainer no, at least not for that kernel release being worked on. I
>> can try to make this a little clearer.
>
> Yes, it would be good if it was clearer.
>
> If maintainer accepts non-intrusive bugfixes during merge window is
> pretty much his decision, I'd say. I'd expect him to take them if he
> has bandwidth available.

OK thanks I'll add that as well.

  Luis
