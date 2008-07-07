Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYGGW0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYGGW0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYGGW0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:26:02 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:35941 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYGGW0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j33DtdfJwPVvbAyEhKJQdsqaoigKrlcOjbVUQZGcCkAtzkSrK/U/Gd5QmbieDpUqrx
         82tW8T0fUexDJdb8WZ2se2udeGczAxJX9oS/zHgzh2uo5AEjL21lG1yeLrzigEqIgnpk
         MwaA6xTC9p3vCZQz7U+8NmkkeqVh/ZBVaIJHU=
Message-ID: <1ba2fa240807071525m222efa91uf2ed009eb7b039b5@mail.gmail.com>
Date: Tue, 8 Jul 2008 01:25:59 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Cc: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>,
       rt2400-devel@lists.sourceforge.net,
       "Stefan Bauer" <stefan.bauer@cs.tu-chemnitz.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200807072319.44733.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
	 <200807072308.57529.IvDoorn@gmail.com>
	 <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com>
	 <200807072319.44733.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 12:19 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Monday 07 July 2008, Stefanik Gábor wrote:
>> On Mon, Jul 7, 2008 at 11:08 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>> > Check if the arc4 and ecb modules are loaded before loading mac80211 & rt2500pci.
>> >
>> > Ivo
>>
>> Shouldn't we make mac80211 depend on arc4 and ecb?
>
> They do depend on those modules, but for some reason they
> are not always automatically loaded when the mac80211 module is loaded.

This is bug is reported very often mostly on ubuntu based distoros.
There is no linkage dependency so it doesn't produce entry in the
depmod.
mac should somehow request these modules dynamically. If I understand
correctly is not so straight forward since there might be alternative
hw acceleration modules for  these modules.

Thanks
Tomas
