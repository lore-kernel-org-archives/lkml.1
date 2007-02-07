Return-Path: <linux-kernel-owner+w=401wt.eu-S1161215AbXBGL1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161215AbXBGL1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161207AbXBGL1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:27:45 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33344 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161215AbXBGL1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:27:44 -0500
X-Sasl-enc: CEyIkzcUaBqNHRFQw3zGCx7OwkH6qHV9+ijyk8S7RqrW 1170847557
Date: Wed, 7 Feb 2007 09:25:39 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070207112539.GD8148@khazad-dum.debian.net>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070202161611.cf8b4328.akpm@linux-foundation.org> <20070203003536.GA619@khazad-dum.debian.net> <1170710913.6105.39.camel@nigel.suspend2.net> <20070206143231.GD18392@khazad-dum.debian.net> <1170797924.14398.19.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170797924.14398.19.camel@nigel.suspend2.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Feb 2007, Nigel Cunningham wrote:
> Ok, as far as usage scenario goes, that's fair enough. But as to the
> solution, I wonder though whether it's making life more complicated than
> it needs to be. After all, we should also be able to cope okay with
> having the power suddenly go out. If we can cope with that, cleaning
> filesystems prior to suspending should be a non-issue.

We don't cope okay with the power going out, at all.  And as an user case, a
need for fsck if you do something that is a reasonable use case (unplugging
devices while suspended) is not okay, either.

> Likewise with changes in hardware. Once hotplugging support is mature,
> suspending, switching around hardware and resuming should just result in
> hot[un]plug events.

Well, if we add *move* events for when someone unplugs a usb stick in one
port and replugs it in another while the system is in lala-land... maybe :-)
It would be normal to do it, when dealing with docks.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
