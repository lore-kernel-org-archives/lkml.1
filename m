Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZBBHre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZBBHre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 02:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZBBHrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 02:47:25 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:60080 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbZBBHrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 02:47:24 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-01.arcor-online.net 867CD3326DD
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Thomas Pilarski <thomas.pi@arcor.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233302270.6061.9.camel@marge.simson.net>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>  <1233229028.4495.34.camel@laptop>
	 <1233237934.11129.183.camel@bugs-laptop>
	 <1233302270.6061.9.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 08:43:55 +0100
Message-Id: <1233560635.4126.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 30.01.2009, 08:57 +0100 schrieb Mike Galbraith:
> One of those "don't _ever_ do that" things?

I did not known random() uses a system call. It's rather unrealistic to
have five million system calls in a second. By adding a small loop with
some calculations near the random, the problem disappears too.
It is a unlucky chosen data generator.


