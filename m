Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbYEEU2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbYEEU2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761659AbYEEU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:28:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:14308 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760116AbYEEU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kfLUdf40XvveMvakVl/SXuyFmAom4/bR9tSD44HpKQrx8tRWSeoctaED4P9LHiGrXMtcsG09JLr5JJM4bP9QHX7LlreXyqUtGi/2VZ/UvbcRgJkPvmhFzaiaLrBV66//gYu3xJaS9dg3Lenk/+s97yOGMWFyxqikhKgYWfI9F3E=
Message-ID: <30c6373b0805051328n30d32202g3744a233c7efb2dd@mail.gmail.com>
Date: Mon, 5 May 2008 13:28:29 -0700
From: "Kevin Burton" <burton@tailrank.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Ability to limit or disable page caching?
Cc: "FD Cami" <francois.cami@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <878wyocy0v.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	 <20080505131607.5556b1f2@olorin>
	 <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	 <20080505212831.22371732@olorin>
	 <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
	 <878wyocy0v.fsf@basil.nowhere.org>
X-Google-Sender-Auth: 9cd623946911b40e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're actually running mlock which is native to MySQL.... of course I
didn't think about whether our secondary process is paging not our
MySQL process.

I'm going to have to look into that and figure out if it's possible to
figure out what apps are being paged.

Kevin

On Mon, May 5, 2008 at 1:10 PM, Andi Kleen <andi@firstfloor.org> wrote:
> "Kevin Burton" <burton@tailrank.com> writes:
>>
>> What I want to do is either disable the page cache entirely or just
>> tell the OS to cache at max 10% of the available memory.
>
> FYI page cache includes the memory your program uses. No page
> cache would mean no user space, 10% would mean user space uses only
> 10%. One way that would fulfil your request literally is to boot with
> mem=<10% of your ram>, but I guess you don't really want that.
>
> If you don't want your application to be swapped at all you
> should probably investigate mlock(2)/mlockall(2)
>
> -Andi
>



-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092
