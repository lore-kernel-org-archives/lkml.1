Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562Ab0BYXpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:45:54 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43184 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934514Ab0BYXpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:45:52 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2010 18:45:52 EST
X-Sasl-enc: ACznfi6OVwZMHRiXaGxoiWyfdL+UpRqXemu1neHQqVIR 1267140918
Date: Thu, 25 Feb 2010 20:35:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: florian@mickler.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2 2/2] enhance sysfs rfkill interface
Message-ID: <20100225233516.GD5218@khazad-dum.debian.net>
References: <1266704345.32739.0.camel@jlt3.sipsolutions.net>
 <1267009517-5017-3-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267009517-5017-3-git-send-email-florian@mickler.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, florian@mickler.org wrote:
> /sys/class/rfkill/rfkill[0-9]+/hw: (ro)
> 	hardblock kill state
> /sys/class/rfkill/rfkill[0-9]+/sw: (rw)
> 	softblock kill state
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
> 
> I am not shure about those names.

I don't like them.  IMHO, you don't gain anything by being this terse, and
it is difficult to understand what they mean at first glance.

> Other alternatives: 
> [hs]w_block
> block_[hs]w

Any of those would be good, IMHO.  As would be more verbose variants like:
hardware_blocked, software_blocked, etc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
