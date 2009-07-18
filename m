Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbZGRPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbZGRPJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZGRPJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:09:17 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35246 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbZGRPJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:09:13 -0400
X-Sasl-enc: 6m7gJmETK0ZWf9ps+cL/g7oto0hnT6UCmWsppk+/fLHu 1247929752
Date: Sat, 18 Jul 2009 12:09:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvram: Fix root triggerable integer overflow crash
Message-ID: <20090718150909.GA1191@khazad-dum.debian.net>
References: <200907180256.45934.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907180256.45934.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jul 2009, Michael Buesch wrote:
> This bug probably is exploitable by overwriting the function return address or something
> like that. But let's hope there's no distribution out there with user write permissions
> on the /dev/nvram node. So it's probably only exploitable by root.

I have seen setups with group-writeable /dev/nvram to support some (old!)
thinkpad utilities.

Even if it cannot be exploited for more than a DoS, IMO that's still bad
enough to warrant fixing this also on stable kernels if they are vulnerable.
So, does the fix also apply to 2.6.27+ ?  If it does, please send it to
stable@kernel.org as well.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
