Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbZAQIse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbZAQIse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 03:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZAQIsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 03:48:25 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:61561 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbZAQIsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 03:48:24 -0500
Message-ID: <49719B53.8050300@gawab.com>
Date: Sat, 17 Jan 2009 00:48:19 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, John Stoffel <john@stoffel.org>
Subject: Re: 2.6.29-rc1 Firefox crashing on page load
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com>
In-Reply-To: <49715039.2090406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> I'm not seeing this with firefox over here.
> The setup I have is the latest beta,
> located in /usr/lib/firefox/ with a soft link to /usr/bin/
> I don't have gnome2 vfs installed though.
> just a bare firefox with 2 plugins(flash,null)
> located in /.mozilla/plugins/
> for restorecon.
>
> not sure what distro you have, but with ubuntu
> I noticed a quit a bit of other links created.
> that is installing through apt-get, rather
> just downloading the source and putting it wherever.
>
> regards;
>
> Justin P. Mattock
>
I'm running ubuntu 8.10, with 2 custom kernels 2.6.28 and 2.6.29-rc2.

I've done a little bit more testing. This time with 4 version of firefox 
(3.0.5-ubuntu, 3.0.4, 3.1.b2, 3.2.a1) straight from mozilla.org, except 
the ubuntu one.
What I found is that all versions crash when loading iGoogle, sofar the 
only site that makes it crash, except 3.2a1.
Since iGoogle is my hompage, they all crash once loading is done (except 
3.2a1), unless I'm fast enough and load a different page.
But, _every_ version crashes if I go to Preferences->Main or 
Preferences->Applications.

None of this crashing happens if I'm booted into a .28 kernel, only on a 
.29-rc kernel.
Henceforth, I still think it's a kernel regression, but one that's going 
to be almost impossible to debug!
I've hit the most narrow minded bug on the planet! Very sad....
Seems like I always hit the undebugable regressions that nobody else 
sees ;-(

Justin Madru
