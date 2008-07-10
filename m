Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYGJBIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYGJBIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYGJBHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:07:55 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35356 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbYGJBHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:07:54 -0400
X-Sasl-enc: g1GKKePkgkoCcBOO7dolZ611EAl2+5Jeq3ZOEru8jYBe 1215652073
Date: Wed, 9 Jul 2008 22:07:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, ak@linux.intel.com,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND] [PATCH -next 2/2] acpi,rfkill,backlight:
	comapl-laptop update - use rfkill switch subsystem
Message-ID: <20080710010749.GB15729@khazad-dum.debian.net>
References: <20080709231059.778d16f4@debian> <200807092333.01355.IvDoorn@gmail.com> <20080709234419.12d6eabc@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709234419.12d6eabc@debian>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008, Cezary Jackiewicz wrote:
> Does calling rfkill_force_state () is mandatory? This driver implement 
> get_state() hook, @state is always up-to-date.

It is not mandatory, but you will get delays and anti-social behaviour if
you don't implement rfkill_force_state() on hardware that can do
HARD_BLOCKED, and rfkill will be able to notice changes only when
"provoked".

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
