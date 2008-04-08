Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYDHWGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYDHWGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 18:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYDHWGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 18:06:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:42507 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYDHWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 18:06:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WUsN888XQzZ+bBnnfgcSWWY1xxYcZWeag2cE1Y9g1h1ZFyxZCRf5zZF/YY89y7vxJTypsWSnbMFl8DjirHUgas0WLwNDCpSYdHZoLgkmZd2iaSPl1do3nXLOr96Wka/wpRSlK9ehKepg7KrslASYckDjZJahhwSDsLhAsIr/rUw=
Message-ID: <47FBEC4B.7030205@gmail.com>
Date: Wed, 09 Apr 2008 00:06:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Wu <flamingice@sourmilk.net>,
       Johannes Berg <johannes@sipsolutions.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in	ieee80211_sta_expire
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com> <20080408183556.GC8183@tuxdriver.com>
In-Reply-To: <20080408183556.GC8183@tuxdriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2008 08:35 PM, John W. Linville wrote:
> On Mon, Apr 07, 2008 at 09:53:48PM +0200, Jiri Slaby wrote:
>> Hi,
>>
>> it's against -mm, what's current mac80211 git tree? It seems that
>> -mm has fresher material, than wireless-2.6...
> 
> As it should.  The wireless-2.6 tree is for feeding the linux-2.6 tree
> (by way of the net-2.6 tree).  Similarly, wireless-2.6.26 feeds -mm
> by way of the net-2.6.26 tree.

Wow, too many trees even with their branches to know the ropes.

> Please use the wireless-testing tree for development, as it contains
> both sets of patches (fixes for the current release and updates for the
> future) as well as a few extras (like drivers still in development).
> Plus it is somewhat more stable, being based off the most a recent
> -rc release rather than just whatever someone last pulled.

Ok, thanks.
