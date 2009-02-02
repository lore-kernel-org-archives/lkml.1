Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZBBIgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZBBIgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 03:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZBBIg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 03:36:26 -0500
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:56695 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbZBBIgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 03:36:25 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-17.arcor-online.net 339313B2696
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Thomas Pilarski <thomas.pi@arcor.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233562763.4787.71.camel@laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>  <1233229028.4495.34.camel@laptop>
	 <1233237934.11129.183.camel@bugs-laptop>
	 <1233302270.6061.9.camel@marge.simson.net>
	 <1233560635.4126.18.camel@localhost.localdomain>
	 <1233562763.4787.71.camel@laptop>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 09:33:20 +0100
Message-Id: <1233563600.3669.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 02.02.2009, 09:19 +0100 schrieb Peter Zijlstra:
> I suppose you'll have to go bug the glibc people about their random()
> implementation.

Yes, I will.

> If you really need random() to perform for your application (monte-carlo
> stuff?) You might be better off writing a PRNG with TLS state or
> something.

I just need some noise in my images.



