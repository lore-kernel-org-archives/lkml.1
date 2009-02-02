Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZBBMQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZBBMQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZBBMQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:16:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:47893 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZBBMQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:16:08 -0500
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Thomas Pilarski <thomas.pi@arcor.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@googlemail.com>
In-Reply-To: <1233564920.4787.108.camel@laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>  <1233229028.4495.34.camel@laptop>
	 <1233237934.11129.183.camel@bugs-laptop>
	 <1233302270.6061.9.camel@marge.simson.net>
	 <1233560635.4126.18.camel@localhost.localdomain>
	 <1233562763.4787.71.camel@laptop>
	 <1233563600.3669.36.camel@localhost.localdomain>
	 <1233564731.21378.9.camel@marge.simson.net>
	 <1233564920.4787.108.camel@laptop>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 13:15:52 +0100
Message-Id: <1233576952.4787.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 09:55 +0100, Peter Zijlstra wrote:

> Ah, that was a good clue, apparently all you need to so it use
> random_r() and provide your own state and all should be well.

Michael, would it make sense to add the random_r() family to the "SEE
ALSO" section of the random() man page?

(Admittedly, my random() manpage is ancient: 2008-03-07, so it might be
this is already the case, in which case, ignore me :)

