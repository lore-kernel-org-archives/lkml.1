Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbZAQJL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbZAQJL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 04:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZAQJLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 04:11:08 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:53191 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbZAQJLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 04:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AUNNU+Isf0rZxGawu3zdZATM+sAwf8Iv1XDlgw0vN5H+lxm9PxSx/OYsLk9Bkg2xuJ
         ZlO4tF2H5PySrS1RfrYPDs2dxBtV+wPEamWifKpFDooiNp+8vMo+aPWrE0M31ZsyqqzK
         oc4wzVjN1DU75xJCTgtCtMv1za8mSOIca7zdc=
Message-ID: <4971A09E.1050503@gmail.com>
Date: Sat, 17 Jan 2009 01:10:54 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
CC: lkml <linux-kernel@vger.kernel.org>, John Stoffel <john@stoffel.org>
Subject: Re: 2.6.29-rc1 Firefox crashing on page load
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com>
In-Reply-To: <49719B53.8050300@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Madru wrote:
> Justin P. Mattock wrote:
>> I'm not seeing this with firefox over here.
>> The setup I have is the latest beta,
>> located in /usr/lib/firefox/ with a soft link to /usr/bin/
>> I don't have gnome2 vfs installed though.
>> just a bare firefox with 2 plugins(flash,null)
>> located in /.mozilla/plugins/
>> for restorecon.
>>
>> not sure what distro you have, but with ubuntu
>> I noticed a quit a bit of other links created.
>> that is installing through apt-get, rather
>> just downloading the source and putting it wherever.
>>
>> regards;
>>
>> Justin P. Mattock
>>
> I'm running ubuntu 8.10, with 2 custom kernels 2.6.28 and 2.6.29-rc2.
>
> I've done a little bit more testing. This time with 4 version of 
> firefox (3.0.5-ubuntu, 3.0.4, 3.1.b2, 3.2.a1) straight from 
> mozilla.org, except the ubuntu one.
> What I found is that all versions crash when loading iGoogle, sofar 
> the only site that makes it crash, except 3.2a1.
> Since iGoogle is my hompage, they all crash once loading is done 
> (except 3.2a1), unless I'm fast enough and load a different page.
> But, _every_ version crashes if I go to Preferences->Main or 
> Preferences->Applications.
>
> None of this crashing happens if I'm booted into a .28 kernel, only on 
> a .29-rc kernel.
> Henceforth, I still think it's a kernel regression, but one that's 
> going to be almost impossible to debug!
> I've hit the most narrow minded bug on the planet! Very sad....
> Seems like I always hit the undebugable regressions that nobody else 
> sees ;-(
>
> Justin Madru
>
what happens when you download the source?
then once unpacked issue ./firefox
just to see what happens without any plugins/apps.

over here I have the beta no apps
basically as light as possible just flash
(since all web sites use that.)

I did have a crash though,
but was due to me not allowing
an allow rule for SELinux(too lazy at the moment);
but besides any allow rules I'm not having any issues.
(knock on wood).

you can also try renaming gnome2 gconf  and
.mozilla just to see

regards;

Justin P. Mattock
