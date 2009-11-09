Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZKIVTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZKIVTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZKIVTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:19:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZKIVTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:19:12 -0500
Message-ID: <4AF8864C.70101@zytor.com>
Date: Mon, 09 Nov 2009 13:14:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arjan van de Ven <arjan@infradead.org>,
       Matteo Croce <technoboy85@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>	<20091003110546.78958508@infradead.org>	<40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com>	<20091003192524.2ca2bd9e@infradead.org> <20091004155802.421b5f93@lxorguk.ukuu.org.uk>
In-Reply-To: <20091004155802.421b5f93@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2009 07:58 AM, Alan Cox wrote:
>> I'm surprised that "i686" in debian depends on the family flag
>> in /proc/cpuinfo.. but hey.. weirder things have been done.
> 
> Its compensating for the old gcc bugs where gcc "i686" generated cmov
> instructions without any checks whether the CPU supported cmov (which is
> optional for a 686 architecture)
> 
> RPM has (or had) similar hacks. Both arguably come about from fundamental
> design thinkos in that they treat architecture as "special", not simply
> as a set of dependancies (needs x86, x86-cmov, glibc x86-32, ...) as
> should hve been done and which would also have made emulators just work
> out of the box instead of the current mess.
> 
> Alan

Well, for gcc, the string "i686" really means "pentiumpro".  All of
these are nothing but named feature sets.

	-hpa
