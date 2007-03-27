Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXC0PiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXC0PiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXC0PiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:38:07 -0400
Received: from krak.alatek.krakow.pl ([217.96.2.229]:1844 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXC0PiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:38:06 -0400
X-Greylist: delayed 1808 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 11:38:05 EDT
Message-ID: <46093349.7060401@agmk.net>
Date: Tue, 27 Mar 2007 17:07:53 +0200
From: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@agmk.net>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: smart gcc inliner...
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The recent gcc (3.4/4.x) optimizer inlines functions across
sections which is definitely not we want, e.g. inlining
functions from .init.text section.

I think, the `__init' macro needs `noinline' attribute and all
the `static inline __{dev}init' functions need `inline' attribute
removal to avoid gcc error (inlining failed, function not inlinable).

Full discussion at: http://gcc.gnu.org/PR31362

BR,
Pawel.

