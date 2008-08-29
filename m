Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYH2QbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYH2QbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbYH2Qax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:30:53 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36009 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbYH2Qaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fNRYJ+u4ZNTxpITLBsxzlIDyG2/AyDE4Gn9L8OCVqc48NlGTbAImGrW4LqTmE0nTyS
         O9JBADIwN510JzvYuS9AQlsMsUMJHfEXvUf1ulV6M7ZCSzDDFTCN+UtXdBMMEwfo2AuH
         K/yQ1F7PejsM7tG5D05oDF/NmVDoXFL2t1/rE=
Message-ID: <b170af450808290930x29f57941k57d2a08d89977ca2@mail.gmail.com>
Date: Fri, 29 Aug 2008 18:30:51 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808291413260.12571@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <48B701FB.2020905@goop.org>
	 <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
	 <48B76CE0.5010309@goop.org>
	 <20080829102547.655440bf@lxorguk.ukuu.org.uk>
	 <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>
	 <Pine.LNX.4.64.0808291120540.8561@blonde.site>
	 <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com>
	 <48B7E6EE.9090901@tuffmail.co.uk>
	 <Pine.LNX.4.64.0808291413260.12571@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7TGVOdq022300

2008/8/29 Hugh Dickins <hugh@veritas.com>:> On Fri, 29 Aug 2008, Alan Jenkins wrote:>> RafaÅ‚ MiÅ‚ecki wrote:>> >>> > I tried your patch anyway (after applying Jeremy's patch of course)>> > and it doesn't seem to work. The only output is:>> > scanning 2 areas for BIOS corruption>> > after using s2ram. I do not get any>> > Corrupted low memory at*>> >>> It seemed to work for me.  Did you remember to plug HDMI to trigger the>> corruption before you used s2ram?>> I hope that's what got missed.
Ah, stupid mistake, sorry! Indeed, using HDMI and s2ram later works fine:
Corrupted low memory at ffff88000000be98 (be98 phys) = b02a000400000000 [<ffffffff8020fc9c>] check_for_bios_corruption+0x94/0xa0
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
