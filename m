Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZBBITp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZBBITp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 03:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZBBITg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 03:19:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46196 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbZBBITf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 03:19:35 -0500
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233560635.4126.18.camel@localhost.localdomain>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>  <1233229028.4495.34.camel@laptop>
	 <1233237934.11129.183.camel@bugs-laptop>
	 <1233302270.6061.9.camel@marge.simson.net>
	 <1233560635.4126.18.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 09:19:23 +0100
Message-Id: <1233562763.4787.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 08:43 +0100, Thomas Pilarski wrote:
> Am Freitag, den 30.01.2009, 08:57 +0100 schrieb Mike Galbraith:
> > One of those "don't _ever_ do that" things?
> 
> I did not known random() uses a system call. It's rather unrealistic to
> have five million system calls in a second. By adding a small loop with
> some calculations near the random, the problem disappears too.
> It is a unlucky chosen data generator.

I suppose you'll have to go bug the glibc people about their random()
implementation.

If you really need random() to perform for your application (monte-carlo
stuff?) You might be better off writing a PRNG with TLS state or
something.

