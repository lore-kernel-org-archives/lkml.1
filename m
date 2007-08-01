Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbXHAN0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbXHAN0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761867AbXHANZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:25:57 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:55816 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761233AbXHANZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:25:56 -0400
Date: Wed, 01 Aug 2007 09:25:51 -0400
To: <tiwai@suse.de>
Cc: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-sound@vger.kernel.org>
Subject: Re: [PATCH 2/3] sound/pci ioremap/iounmap balancing
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070801132551.5A8132281F@mailserver9.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 01 Aug 2007 06:38:16 -0400 Takashi Iwai <tiwai@suse.de> 
wrote:
>This would be rater a lacking check of returned errors.
>
>The other changes look incorrect.  All these drivers use
>card->private_free callback to release the resources even for the
>error exit.  Thus, you don't need iounmap in each place.
>
>
>thanks,
>
>Takashi


Missed the callback on the audit, will repost this patch 
(sound/pci) with just the unchecked returns...

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------

--
Click for free information on attaining an equity line of credit.
http://tagline.hushmail.com/fc/Ioyw6h4d9K1rpVNolPplpaj6Tmr87LwpU4yqszBO6uxXkrRlUIHweI/

