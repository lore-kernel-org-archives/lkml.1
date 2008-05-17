Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYEQNpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYEQNpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYEQNpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:45:13 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51437 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYEQNpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:45:11 -0400
Cc: netdev <netdev@vger.kernel.org>, Jean Tourrilhes <jt@hpl.hp.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Message-Id: <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1211026337.3827.25.camel@johannes.berg>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
Date: Sat, 17 May 2008 15:45:04 +0200
References: <1211026337.3827.25.camel@johannes.berg>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> The /sys/class/net/*/wireless/ direcory is, as far as I know, not
> used by anyone. Additionally, the same data is available via wext
> ioctls. Hence the sysfs files are pretty much useless. This patch
> makes them optional and schedules them for removal.

it is used by HAL to classify WiFi network cards as net.80211 instead  
of net.80203 and so we do have an actual user. However HAL only tests  
for the existence of the directory wireless/.

Please fix HAL first before submitting such a patch.

Regards

Marcel

