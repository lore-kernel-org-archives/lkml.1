Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYH2KNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYH2KNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYH2KNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:13:36 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:3577 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYH2KNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IpddzEE+3N+FyK2f/o8bIlQHKkBKQTrJ/LPfjfeqWZyrDBJqfkEsTaxEPMkUMn7bVD
         abudCsKij1csxxW5McAnhTrMjhou88bsBvK6NS/oNx7BF2Bz3I98mQx6V4s6RNJQa3r4
         Y7xK1H6TFhUuURvL2iJ3+QhBTof4kEVdhXoBc=
Message-ID: <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>
Date: Fri, 29 Aug 2008 12:13:34 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Hugh Dickens" <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080829102547.655440bf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <48B701FB.2020905@goop.org>
	 <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
	 <48B76CE0.5010309@goop.org>
	 <20080829102547.655440bf@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7TADodq017606

Out of current discussion I tried using s2ram on patched kernel (I didnot try s2ram earlier, my problem was (un)plugging HDMI - some ACPIcode probably).
Corruption output is quite huge, I attached it to bug report:http://bugzilla.kernel.org/show_bug.cgi?id=11237http://bugzilla.kernel.org/attachment.cgi?id=17526

I do not know much about current discussion and fact if checking forcorruption should be enabled by default.
However, please note that end-user will not able to diagnose thatLinux doesn't work on his machine because of less-or-more broken BIOS.He will not get to know that he needs to enablebios_corruption_check=1 and edit grub to make it default.
I understand that disabling chunk of RAM on every, even not affected,machine is far from perfect, but we have to remember about notadvanced end-users.
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
