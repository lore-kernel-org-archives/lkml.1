Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZHGRvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZHGRvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZHGRvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:51:37 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:56277 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbZHGRvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TlLowmTfZHpcYDVlaLY6g1volUvQn3rFNel7hYPTLl0W5Jg+EX3Zru6A3TewX6fJTN
         yyrHw+YrBalHpehy3ZfFKJpkv4nWl87Syi1qH+ucumq3Zrt6JtJdIZ1UmKrLxKzY83Oc
         XPk2dqCrfEfJAId0QYDLWpAkl+aONhNC6P91g=
MIME-Version: 1.0
In-Reply-To: <200908071939.49627.elendil@planet.nl>
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com> 
	<20090807151304.GE7545@tuxdriver.com> <43e72e890908071013w28644e70h5323e19d19da33a2@mail.gmail.com> 
	<200908071939.49627.elendil@planet.nl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 7 Aug 2009 10:51:17 -0700
Message-ID: <43e72e890908071051w1f306349rfab32de80759006e@mail.gmail.com>
Subject: Re: ath5k - strange regulatory domain change
To: Frans Pop <elendil@planet.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Chris Clayton <chris2553@googlemail.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 10:39 AM, Frans Pop<elendil@planet.nl> wrote:
> On Friday 07 August 2009, you wrote:
>> The way the EEPROM was programmed for this type of
>> regulatory domain was to give you a group number under which other
>> countries fall under. If you ended up getting a direct alpha2
>> programmed in the EEPROM instead you would still end up matching the
>> alpha2 to a group number. The group number leads you to a regulatory
>> domain that all those countries in that group number adhere to. So it
>> was a way to group up regulatory domain rules between countries. The
>> "CN" you see just so happens to be the alpha2 for the first country in
>> the same group regulatory domain group.
>>
>> What we can do is to elaborate on that on the dmesg and also maybe
>
> That would be very welcome.
>
>> pick the most common country on the group so it will tend to match the
>> country users are on.
>
> I think that would just be moving the problem from one group of users to
> another, possibly only marginally smaller, group of users.
>
> As far as I can see the largest group is ETSI1_WORLD and contains 33
> countries, followed by NULL1_WORLD (is that a real group?) with 22.
> That's probably too many to list them all.
> OTOH, all other groups contain at most 7 countries, which could possibly
> be listed.
>
> Probably the simplest option would be to just display some identification
> of the domain group itself and point users to documentation which
> explains what countries fall under what groups. That would at least avoid
> the confusion caused by randomly picking a matching country.
> Variation could be to display the country if the group only contains one
> country, but that could also be considered an inconsistent user
> interface.

Or maybe see if the currently set regulatory domain matches an alpha2
in the group, if so then just display the same alpha2. Will take a
look.

  Luis
