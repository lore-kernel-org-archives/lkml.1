Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYKKSGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYKKSGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbYKKSFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:05:52 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:47821 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556AbYKKSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:05:51 -0500
Message-ID: <4919C979.3000501@euromail.se>
Date: Tue, 11 Nov 2008 19:05:45 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Complete support for the new unibody macbooks
References: <49109C91.6090207@euromail.se> <alpine.LNX.1.10.0811111835540.24889@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811111835540.24889@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1Kzxca-0002rx-7z.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Kzxca-0002rx-7z 9c8791f417f3b9efb50c8428d2f1fa98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 4 Nov 2008, Henrik Rydberg wrote:
> 
>> The unibody MacBook 5 and MacBook Pro 5 come with a new version of
>> the bcm5974 trackpad. This patch adds the USB device ids and all
>> the appropriate quirks, including hid_blacklist.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Applied, thanks Henrik (and sorry for the delay, I have been offline for a 
> few days).
> 

No worries. I should have mentioned earlier that the hid update
is best synchronized with the bcm5974 update, since the latter
is the only driver that will pick the mouse interface up after
the hid update. The bcm5974 patch was sent on October 23, but
I have not received any feedback to it yet.

Cheers,
Henrik

