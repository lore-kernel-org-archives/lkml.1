Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZLCSXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZLCSXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZLCSXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:23:31 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:2507 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZLCSXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:23:30 -0500
Date: Thu, 3 Dec 2009 10:23:36 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Lior Dotan <liodot@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
Message-ID: <20091203182336.GA21309@hexapodia.org>
References: <4B151FE2.3090807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B151FE2.3090807@gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 03:53:38PM +0200, Lior Dotan wrote:
> Ever since I've upgraded to rc8, my T500 fails to suspend to RAM for the
> second time. Suspending for the first time works ok but when I resume and
> later try to suspend again the screen gets blank and the moon LED blinks
> forever. rc6 & rc7 as well as 2.6.31 worked great with out a problem.

How are you suspending -- pm-suspend, gnome power manager, closing the
lid, ... ?

Could you compare the dmesg between rc7 and rc8 after the first suspend
and look for any likely differences?  (I use "diff -W160 --side-by-side"
for this.)

-andy
