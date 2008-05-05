Return-Path: <linux-kernel-owner+w=401wt.eu-S1761856AbYEESrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856AbYEESrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762602AbYEESe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:34:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:32788 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762591AbYEESe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=adcwC/h0VlUtpflZdVwxMH/7rsOxEfip15IlQGUr5voTj7XUmkBVuXP04Wb+uoEXxKg2aGizJHVEO21YtJbRdyiybNR3hf+r6oronisWcBiTMh8/0cXR/7Sc4267bErTJzJznBkabyq8QsT8RF0GvDWXTuHN28ddeZ972CosGn0=
Message-ID: <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
Date: Mon, 5 May 2008 11:34:24 -0700
From: "Kevin Burton" <burtonator@gmail.com>
To: "FD Cami" <francois.cami@free.fr>
Subject: Re: Ability to limit or disable page caching?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080505131607.5556b1f2@olorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	 <20080505131607.5556b1f2@olorin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In the mean time is it possible to disable the page cache or limit it
>> to say 10% of system memory?
>
> You might want to look at /proc/sys/vm/ for tunables.
> /proc/sys/vm/vfs_cache_pressure and /proc/sys/vm/swappiness are probably
> what you are looking for.

I haven't played with vfs_cache_pressure so I'll take a look at this.

Unfortunately, swappiness doesn't work as intended.

> See this article for an explanation of swappiness :
> http://www.leap-cf.org/oldarchive/2004-May/038622.html
>
>> You could do this with RHEL 4.x but I don't recall this ever making it
>> into 2.6 :-/
>
> AFAIK RHEL 4.x runs 2.6.9.

OK... maybe it was 3.x .. I might be getting confused with their
kernel release numbers.

Kevin

-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092
