Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbZANNcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbZANNcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZANNcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:32:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZANNcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:32:32 -0500
Subject: Re: deadlocks if use htb
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Denys Fedoryschenko <denys@visp.net.lb>, Chris Caputo <ccaputo@alt.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090114132603.GD6117@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local>
	 <200901141417.58667.denys@visp.net.lb> <1231937404.14825.4.camel@laptop>
	 <200901141505.46929.denys@visp.net.lb> <20090114131257.GC6117@ff.dom.local>
	 <1231938929.14825.6.camel@laptop>  <20090114132603.GD6117@ff.dom.local>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 14:32:26 +0100
Message-Id: <1231939946.14825.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 13:26 +0000, Jarek Poplawski wrote:

> OK, I hope Denys can apply more, but what about others? Without any
> patches the hole seems to be much bigger.

OK, I read most of this thread on netdev, but didn't find a clear clue
on the specific hrtimer insertion race.

Do you have any clear ideas or should I poke at the htb/hrtimer code a
little?

