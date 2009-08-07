Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZHGRjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZHGRjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZHGRjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:39:51 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:58499 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754650AbZHGRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:39:50 -0400
From: Frans Pop <elendil@planet.nl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ath5k - strange regulatory domain change
Date: Fri, 7 Aug 2009 19:39:48 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Chris Clayton <chris2553@googlemail.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com> <20090807151304.GE7545@tuxdriver.com> <43e72e890908071013w28644e70h5323e19d19da33a2@mail.gmail.com>
In-Reply-To: <43e72e890908071013w28644e70h5323e19d19da33a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908071939.49627.elendil@planet.nl>
X-OriginalArrivalTime: 07 Aug 2009 17:39:50.0161 (UTC) FILETIME=[10654810:01CA1786]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, you wrote:
> The way the EEPROM was programmed for this type of
> regulatory domain was to give you a group number under which other
> countries fall under. If you ended up getting a direct alpha2
> programmed in the EEPROM instead you would still end up matching the
> alpha2 to a group number. The group number leads you to a regulatory
> domain that all those countries in that group number adhere to. So it
> was a way to group up regulatory domain rules between countries. The
> "CN" you see just so happens to be the alpha2 for the first country in
> the same group regulatory domain group.
>
> What we can do is to elaborate on that on the dmesg and also maybe

That would be very welcome.

> pick the most common country on the group so it will tend to match the
> country users are on.

I think that would just be moving the problem from one group of users to 
another, possibly only marginally smaller, group of users.

As far as I can see the largest group is ETSI1_WORLD and contains 33 
countries, followed by NULL1_WORLD (is that a real group?) with 22. 
That's probably too many to list them all.
OTOH, all other groups contain at most 7 countries, which could possibly 
be listed.

Probably the simplest option would be to just display some identification 
of the domain group itself and point users to documentation which 
explains what countries fall under what groups. That would at least avoid 
the confusion caused by randomly picking a matching country.
Variation could be to display the country if the group only contains one 
country, but that could also be considered an inconsistent user 
interface.

Cheers,
FJP
