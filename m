Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYDXJNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYDXJNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYDXJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:13:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:65257 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYDXJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SF75GEJYS+Cl+0wp+xlTX3rQ4OGR3ip5nA+Xv5MDwdoNEMyeQwsVbQTCFBfTYBoiZ0SxS9HxHvZ8koMkMWJnaHldytmmQh3LO6DLSVA6SEZTQqehi2zsKGoGdRVbAVc7a9l8Bbqg9f0OHWGWRfCY278LWgi/FEJRU4g2csSmTyA=
Message-ID: <1ba2fa240804240213p77f0b96do4da6a2504fac1c65@mail.gmail.com>
Date: Thu, 24 Apr 2008 12:13:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
Subject: Re: iwl4965 regression since 2.6.24
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20080423233904.GD14412@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <20080423124105.GA4783@ics.muni.cz>
	 <D936D925018D154694D8A362EEB0892004415BC8@orsmsx416.amr.corp.intel.com>
	 <20080423233904.GD14412@ics.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3O9EREB007065

2008/4/24 Lukas Hejtmanek <xhejtman@ics.muni.cz>:> On Wed, Apr 23, 2008 at 02:29:14PM -0700, Chatre, Reinette wrote:>  > Could you please send us some logs that can help us debug this problem?>  > Please load the driver with debugging (modprobe iwl4965 debug=0x43ffb)>  > to get detailed logs and add a detailed description about what you are>  > trying to do with the driver as the logs are created. Also, please>  > consider filing a bug at http://www.intellinuxwireless.org/bugzilla/>  > with these logs attached.>>  done at:>  http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1659>>  -->  Luká¹ Hejtmánek>  -->  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in>
ThanksSince we moved association process out of the driver and relaying onmac80211 association, it lookslike disassociation is not handled properly and previous configurationis not cleared correctly.  Probably in both levelsmac and the driver.Investigating....
ThanksTomas
> the body of a message to majordomo@vger.kernel.org>  More majordomo info at  http://vger.kernel.org/majordomo-info.html>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
