Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbZHFUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbZHFUPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZHFUPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:15:50 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:43142 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbZHFUPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G9h86WdDu5y8ov78tWgN8W7f4vAr1aLxKRf55wA3KIzPncwDATtCsluNtjokIuKetr
         +/Gsvmts2L5hKweCerVDUCvHQOdlmw9QYFwiUMtWuJI6O4Ij1Q2jcDDhCrnAzlu3D/gu
         cHczDnf5yWq7xE9MvKKbPVoCTakebLI6eFT0Q=
MIME-Version: 1.0
In-Reply-To: <43e72e890908061232k467ba1f7iece5d0aa9bece811@mail.gmail.com>
References: <b637ec0b0908061130w399eb1c6oc3a31640a76398c5@mail.gmail.com>
	 <20090806183247.GI26809@tuxdriver.com>
	 <b637ec0b0908061226m33203bco7ac38cecb939b382@mail.gmail.com>
	 <43e72e890908061232k467ba1f7iece5d0aa9bece811@mail.gmail.com>
Date: Thu, 6 Aug 2009 22:15:48 +0200
Message-ID: <b637ec0b0908061315s3614603dya1ac800445b748bf@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/mlme.c:2292 ieee80211_sta_work+0x97/0xd2d 
	[mac80211]()
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis.
I'm using 2.6.31-rc5 and I'm not using wireless-testing.

Regards,
Fabio



On Thu, Aug 6, 2009 at 9:32 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Thu, Aug 6, 2009 at 12:26 PM, Fabio Comolli<fabio.comolli@gmail.com> wrote:
>> Hi John. I'm using ath5k .
>>
>> The card is a:
>>
>> 01:00.0 Ethernet controller: Atheros Communications Inc. AR5001
>> Wireless Network Adapter (rev 01)
>>
>> with PCI ID:
>>
>> 01:00.0 0200: 168c:001c (rev 01)
>
> What kernel?
>
> This is probably a driver/mac80211 adding work into the mac80211
> workqueue during the susend --> resume cycle. We recently changed the
> warning to be moved onto the actual caller who does the queue_work()
> so we don't have to guess at this and do a painful debugging.
>
> I suspect you are not using the latest wireless-testing.
>
>  Luis
>
