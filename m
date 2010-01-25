Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639Ab0AYSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0AYSof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747Ab0AYSoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:44:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59726 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932107Ab0AYSoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:44:32 -0500
Date: Mon, 25 Jan 2010 18:43:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
Message-ID: <20100125184350.0fbad233@lxorguk.ukuu.org.uk>
In-Reply-To: <20100125103525.2b766b9c@jbarnes-piketon>
References: <201001240055.59479.rjw@sisk.pl>
	<20100125103525.2b766b9c@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This probably belongs in the core DRM KMS code instead of the driver.
> I can imagine that there may be some X driver code that still needs to
> be executed on suspend/resume for some drivers, so this may introduce
> bugs, but it's definitely the right way to go.

You can have a mix of KMS and non KMS consoles active on different cards.
So I don't think that is the case.
