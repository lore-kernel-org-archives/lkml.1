Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbYKNV2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbYKNV2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYKNV2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:28:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:14103 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYKNV2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:28:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cPoaUgWvaAdk0NB5LGOUUZXpVaG/2qseGMiDp0LKfybsYRKtxNkFBqcUnmZqgPsrx/
         /mxiIHi8VnIiwQbiV57+Zh7HSh/9twUIlHmUy0XKvZhZeL6kZwrzrg4n/XyyXqXk/+K1
         bcJm+oYKibReeWh7OgFF+CLCbnnROd7wq52EY=
Message-ID: <3aaafc130811141328n61b3fe43wd838140ef350f219@mail.gmail.com>
Date: Fri, 14 Nov 2008 16:28:13 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for November 14 (staging/agnx/)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081114111517.c2d9b2f9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114184021.ed198f4b.sfr@canb.auug.org.au>
	 <20081114111517.c2d9b2f9.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 2:15 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Fri, 14 Nov 2008 18:40:21 +1100 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20081113:
>>
>> New tree:
>>       staging
>
>
> drivers/staging/agnx/pci.c:327: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
> drivers/staging/agnx/pci.c:328: error: 'struct ieee80211_if_conf' has no member named 'ssid'
> drivers/staging/agnx/pci.c:328: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
> drivers/staging/agnx/pci.c:329: error: 'struct ieee80211_if_conf' has no member named 'ssid'
> drivers/staging/agnx/pci.c:329: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
> drivers/staging/agnx/pci.c:330: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
> drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
> drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid_len'
> drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid'
> drivers/staging/agnx/pci.c:331: error: 'struct ieee80211_if_conf' has no member named 'ssid

It looks like commit 41bb73eeac5ff5fb217257ba33b654747b3abf11 removed
these members from ieee80211_if_conf under the assumption that no
drivers used them.

>
> config attached.
>
> ---
> ~Randy
>
