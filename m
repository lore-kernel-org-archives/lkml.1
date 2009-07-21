Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZGUPLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZGUPLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZGUPLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:11:10 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33051 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754365AbZGUPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:11:08 -0400
X-Sasl-enc: e6IvbWOAalT0nFlEIswdPcaqoEPqd3Rce/hCBhfTfACi 1248189067
Date: Tue, 21 Jul 2009 12:10:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
Message-ID: <20090721151058.GA22182@khazad-dum.debian.net>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com>
 <20090714235332.GA1552@ucw.cz>
 <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
 <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com>
 <20090718103756.GA11381@elf.ucw.cz>
 <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com>
 <20090718235609.GC25343@khazad-dum.debian.net>
 <43e72e890907200927j40ee0f35j6c9c2ede09f5dca6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890907200927j40ee0f35j6c9c2ede09f5dca6@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009, Luis R. Rodriguez wrote:
> >> > What about simply reporting "wake event happened on this device" and
> >> > doing that for all the devices?
> >>
> >> That's fine too. Just think it would be nice to be more specific if possible.
> >
> > A generic way for a device (of any sort, not just network devices!) to
> > report that they just issued a system wakeup message, as well as the reason
> > it did that seems like a good way to do it to me.
> 
> This should be easy to do via udev events.
> 
> How about an generic platform registered, and udev events issues for
> wake-up-triggers, and also for wake-up-events, and leave all the
> sorting out to userspace? All we'd need in-kernel would be the trigger
> registration and event trigger notifications.

I am fine with it.  Please CC me if you write some code for that ;-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
