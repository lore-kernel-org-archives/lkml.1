Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYIFCdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYIFCdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 22:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYIFCdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 22:33:05 -0400
Received: from senator.holtmann.net ([87.106.208.187]:55626 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYIFCdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 22:33:04 -0400
Subject: Re: [PATCH 1/2 v5] cfg80211: Add new wireless regulatory
	infrastructure
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1220643824-11398-1-git-send-email-lrodriguez@atheros.com>
References: <1220643824-11398-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 04:33:14 +0200
Message-Id: <1220668394.6714.109.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> This adds the new wireless regulatory infrastructure. The
> main motiviation behind this was to centralize regulatory
> code as each driver was implementing their own regulatory solution,
> and to replace the initial centralized code we have where:
> 
> * only 3 regulatory domains are supported: US, JP and EU
> * regulatory domains can only be changed through a module parameter
> * all rules are built statically in the kernel
> 
> We now have support for regulatory domains for many countries
> and regulatory domains are now queried through a userspace agent
> (CRDA) through udev allowing distributions to update regulatory rules
> without updating the kernel. Updates on regulatory rules can
> now be left as an independent effort.

can we get a small document in Documentation/ that describes what has to
be done for CRDA. That would help to ease the adaption and would allow
us to point people to it. Nothing fancy, but some quick notes where to
find it and what to put where.

> Each driver can regulatory_hint() a regulatory domain
> based on either their EEPROM mapped regulatory domain value to a
> respective ISO/IEC 3166-1 country code or pass an internally built
> regulatory domain. We also add support to let the user set the
> regulatory domain through userspace in case of faulty EEPROMs to
> further help compliance.

Do we have an example for all the possible ways? I think about something
to help driver maintainers to move over and use the infrastructure the
right way.

Regards

Marcel


