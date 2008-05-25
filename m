Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYEYNrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYEYNrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYEYNrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:47:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbYEYNrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:47:16 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Buesch <mb@bu3sch.de>, Marcel Holtmann <marcel@holtmann.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
In-Reply-To: <20080525141638.65111d64@core>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <200805251149.41059.mb@bu3sch.de>
	 <9995307A-E602-4A30-8900-6AEDDF7D1D8F@holtmann.org>
	 <200805251414.04509.mb@bu3sch.de>  <20080525141638.65111d64@core>
Content-Type: text/plain
Date: Sun, 25 May 2008 14:46:58 +0100
Message-Id: <1211723218.31212.104.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-25 at 14:16 +0100, Alan Cox wrote:
> > What if I want 2 or 3 different firmware versions installed at once?
> > I'll have to play dirty tricks with the filenames then and put several
> > unrelated firmware versions into one directory. That's going to be a mess.
> 
> You add the desired feature to udev, or use symlinks. Hardly a "mess".

It's a bit of a pain for the in-kernel firmware loading that I'm working
on now, if we can no longer count on the requested string to be the
single match criterion.

-- 
dwmw2

