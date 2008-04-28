Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbYD1HmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbYD1HmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764994AbYD1Hl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:41:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:52923 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763414AbYD1Hl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aWiTDWlKfyl5a+NlOvyRLsZIfJvsRXzVzm2hsPkg4LV+xhk6FJdDroqaS+rPFgonG+nocbcf6ah2Or/0qavza0a8c59hSL9+5NWcacZnAsPen/VOrfoaHfxN6tnSehiYkYushtPxp7/mXMgO3up3zKoRjKDkr84q8isHrxb3u5Q=
Message-ID: <48157FBE.30008@gmail.com>
Date: Mon, 28 Apr 2008 09:41:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Chris Peterson <cpeterso@cpeterso.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix warning: remove unused static function in drivers/char/ip2/i2ellis.c
References: <a24804730804270009x3398a190wf68e52280015fc7f@mail.gmail.com>	 <48142E5B.3000109@gmail.com> <a24804730804271851j61ded9c2tf1c15b6da845050c@mail.gmail.com>
In-Reply-To: <a24804730804271851j61ded9c2tf1c15b6da845050c@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2008 03:51 AM, Chris Peterson wrote:
> Yes, I did compile it, but I now realize I had compiled the computone
> driver to be linked statically, but iiEllisCleanup() is only called
> when the driver is built as a module. What is the appropriate cleanup
> code path for non-modular drivers?

Remove the function and all its references.
