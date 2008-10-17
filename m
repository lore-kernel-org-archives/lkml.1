Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYJQVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYJQVYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYJQVYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:24:23 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:23702 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYJQVYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TG6fxsJPBNYIdx75JSDHqhX7maroj/LNqNOpdS6Xm/RulrPIFgtRf5b1OcOe34e2CU
         p+h/eVzFijsVhiQpAiwIcK7qdFw2b5f7Ay6TOsRbSjkD3Jx2gC1Is+E+UykeDBrQfmvT
         QfDNEwEMQFsUYKA5LeMEpXQMikts+wmzKKRo8=
Message-ID: <43e72e890810171424n7c8ac058u4d8e9821d0e2a5eb@mail.gmail.com>
Date: Fri, 17 Oct 2008 14:24:21 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "=?UTF-8?Q?Stefanik_G=C3=A1bor?=" <netrolller.3d@gmail.com>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "=?UTF-8?Q?J.A._Magall=C3=B3n?=" <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Dan Williams" <dcbw@redhat.com>,
       "Tim Gardner" <tim.gardner@canonical.com>
In-Reply-To: <69e28c910810171341g4adee0e9t6f551119f076813e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20081014010202.71d13eaf@werewolf.home>
	 <20081013232432.GB32550@tuxdriver.com>
	 <43e72e890810131723k227ff97bya17aee0d9a5da2b@mail.gmail.com>
	 <69e28c910810171341g4adee0e9t6f551119f076813e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9HLOadq023263

On Fri, Oct 17, 2008 at 1:41 PM, Stefanik GÃ¡bor <netrolller.3d@gmail.com> wrote:> On Tue, Oct 14, 2008 at 2:23 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:>>>> cfg80211: Unknown parameter `ieee80211_regdom'>>>> Ahh this one.. this is the 2 character module parameter you can pass>> to cfg80211 upon load and this is available only when>> CONFIG_WIRELESS_OLD_REGULATORY is enabled.>>>> I still don't see why you are seeing this, as your modprobe command>> did not pass any module parameter options.. do you have some options>> for cfg8021 in your distribution place for them on /etc/ somewhere?>>>> <snip>>>>>  Luis>>>> Let me have a guess: /etc/modprobe.d/options:> options cfg80211 ieee80211_regdom="EU">> I also have this in my modprobe options file to avoid having to unload> all wireless drivers and stack modules, then reload manually. Possibly> some distros auto-set this based on the country selection. Though I> agree that CRDA is way neater.
Yeah OK so you can remove this then.
  Luisÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
