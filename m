Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0CDBPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:15:41 -0500
Received: from mail-ew0-f172.google.com ([209.85.219.172]:42490 "EHLO
	mail-ew0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab0CDBPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:15:36 -0500
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 20:15:35 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JxKfNubXkXBwYo4nABLAynxDYSn8M+vzzZJKMcZo6M7EkUIZRnMD3VAv/tZODIO3wP
         rwakSHGsGenOeSjXNMKNi1aizVwrkVxwFfSnoRotqRfUq+yRS8TDunw/PTMv2FRZdfqC
         CY96nsz9vrWK27cubghMwEUjZQ3oTS2L5qEBU=
Subject: Re: Linux Bluetooth Coexistence documentation in general and for
 ath9k
From: Bastien Nocera <hadess@hadess.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Kevin Hayes\" <kevin@atheros.com>, \"Dan Tian\"" 
	<Dan.Tian@atheros.com>
In-Reply-To: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com>
References: <43e72e891003031643u353c72dcj23bf429363a16ec8@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 04 Mar 2010 00:59:13 +0000
Message-ID: <1267664353.10407.1960.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.90 (2.29.90-2.fc13)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 16:43 -0800, Luis R. Rodriguez wrote:
> Marcel, a question for you below.
> 
> The question of Bluetooth coexistence pops up here, on IRC and on bug
> reports quite too often so I've stuffed what I could onto a page with
> a few references / code and about ath9k's schemes for BT coexistence,
> feel free to extend or correct:
<snip>
> I do wonder if this could be useful to network applets like network
> manager/connman.

Not really. To me, it sounds like a "make it work" button. The kernel
bits of Bluetooth should already have an idea of when a device is
connected, so the kernel should be able to "do the right thing".

Having options over what "the right thing" is is probably a good idea
whilst the kinks are worked out from the default behaviour, but this is
not something that should be advertised to users.

>  The other BT coex schemes are BT specific it seems
> and not sure if those devices can expose that information out and
> inform userspace of certain events.

Cheers

