Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZKIVRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZKIVRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZKIVRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:17:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZKIVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:17:12 -0500
Message-ID: <4AF886D4.1080108@zytor.com>
Date: Mon, 09 Nov 2009 13:17:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca>
In-Reply-To: <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 12:16 PM, Lennart Sorensen wrote:
> 
> The Geode LX is what is being discussed which is in fact mostly a K6 as
> far as I understand things.  It seems to like i686 code, other than
> apparently those NOP instructions.  I wonder if the K6 has those noop
> instructions and if not, perhaps gcc 4.4's -march=k6-3 would be the
> right choice.  I have always suspected the LX was really a K6-3 based
> design (the cache sizes are a bit different, but clock speeds and
> instruction sets seem to match).
> 
> The Geode NX (which no one has mentioned yet) is an Athlon derived chip.
> 

*As far as I know* K6 didn't have NOPL, whereas K7 does.

Someone who has access to these chips could run that as an experiment.

	-hpa
