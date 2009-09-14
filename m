Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbZINRK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbZINRK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbZINRK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:10:56 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59708 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263AbZINRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:10:55 -0400
X-Sasl-enc: 23RcUolEw696mfsbelZDHOlFJIqRj0j0XpvG9aofUoPj 1252948258
Date: Mon, 14 Sep 2009 14:10:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Corentin Chary <corentincj@iksaif.net>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/3] rfkill_unregister() should always be followed by
 rfkill_destroy()
Message-ID: <20090914171056.GB13452@khazad-dum.debian.net>
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net>
 <20090914132401.GC32253@khazad-dum.debian.net>
 <4AAE59CB.8030702@tuffmail.co.uk>
 <20090914170717.GA13452@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914170717.GA13452@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Henrique de Moraes Holschuh wrote:
> I don't know about the fix for dell-laptop since it is a lot larger.

But looking at it, it seems to meet the -stable criteria as well.  However,
it looks like you're fixing two bugs there (set pointers to NULL, call
_destroy()), so it would be better to have two (smaller) patches, maybe?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
