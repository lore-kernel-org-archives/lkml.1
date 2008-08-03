Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYHCRE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYHCRE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYHCREv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:04:51 -0400
Received: from gw.beattie-home.net ([66.93.38.225]:46186 "EHLO
	mail.beattie-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbYHCREv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:04:51 -0400
Subject: Re: ioctl's suck?
From: Brian Beattie <beattie@beattie-home.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080803135622.7f624327@lxorguk.ukuu.org.uk>
References: <1217714096.6280.35.camel@kokopelli>
	 <20080803135622.7f624327@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 10:04:55 -0700
Message-Id: <1217783095.6280.63.camel@kokopelli>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 13:56 +0100, Alan Cox wrote:
> > I could add a control device and pass ascii strings for status and OOB
> > messages, would that be an improvement?
> 
> Usually not. The idea that ioctl can be replaced with ascii messages is
> clueless rubbish that generally gets spouted by people with their head
> in the clouds of conceptual elegance and no grasp of reality.

Yeah, I can see that.  Though the case has been made that ioctls are
only usable by C/C++ while I'm sure there are other languages, I'm
working in the embedded space and mostly work with C and sh so my
experience is limited and that is of less direct importance to me.

> 
> There are certain things you can expose that way usefully via sysfs
> - things like general stateless status information. Ioctl however provides
> an interface tied to file handle not name (which is essential in a hotplug
> environment) and an ordering to events so you know the response you get
> matches the query you made.

Yeah coherence (if I'm using that word correctly) would be critical, and
a separate file handle would make that tricky.


> Alan
-- 
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting a bad thing?

Brian Beattie   LFS12947 | "Honor isn't about making the right choices.
beattie@beattie-home.net | It's about dealing with the consequences."
www.beattie-home.net     | -- Midori Koto

