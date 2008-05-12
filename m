Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYELU5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYELU5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYELU5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:57:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44659 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYELU5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:57:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4828AEEC.2010705@s5r6.in-berlin.de>
Date: Mon, 12 May 2008 22:56:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Oliver Hartkopp <oliver@hartkopp.net>
CC: Romano Giannetti <romanol@upcomillas.es>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com>	 <48198873.7030503@hartkopp.net>  <481A06C0.6070500@zytor.com> <1210163964.14371.1.camel@localhost> <48282C69.2070006@hartkopp.net>
In-Reply-To: <48282C69.2070006@hartkopp.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Hartkopp wrote:
> Romano Giannetti wrote:
>> What about a -rc0 as the first commit after a release? Will help a lot
>> automatic installing scripts...

What is "a lot"?  Maybe the solution is to switch from sh to bash.

> Yes - this was also my intention. I don't have any preferences if the 
> first commit after a release is named -merge or -rc0. But it should 
> point out that we're leaving the former stable release.

2.6.25-git8 says exactly this.  It is a nightly generated patch on top 
of 2.6.25, retrieved from the then current linux-2.6.git.

If you see a -gitX then you know that this is not a release, it is only 
a snapshot.

Your proposed -rc0 on the other hand has, in addition to the drawbacks 
which H. Peter already mentioned, the problem that there would be 
suddenly two release names for one and the same release.  This would 
only increase confusion.

Anyway.  You can always add your own tags in your cloned repository.
-- 
Stefan Richter
-=====-==--- -=-= -==--
http://arcgraph.de/sr/
