Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbXDMMIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbXDMMIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXDMMIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:08:42 -0400
Received: from khc.piap.pl ([195.187.100.11]:47378 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbXDMMIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:08:41 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: initramfs unpack point and rules
References: <m3ejmzdmow.fsf@maximus.localdomain>
	<20070412110637.GG4095@ftp.linux.org.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 13 Apr 2007 14:08:39 +0200
In-Reply-To: <20070412110637.GG4095@ftp.linux.org.uk> (Al Viro's message of "Thu, 12 Apr 2007 12:06:37 +0100")
Message-ID: <m3slb4xyrc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> writes:

> Nope.  The point is to have it as early as possible, so that we had more
> or less normal environment when drivers, etc. are being initialized.

But traditionally the "normal environment" is a root fs not yet
mounted. Do the drivers need initramfs? Which drivers?

In both cases it's a bit before /sbin/init (or /init) is launched,
udevd isn't running and firmware can't be loaded.

OTOH when something goes wrong before console drivers are initialized,
nothing can be seen. And with initramfs (especially with the external
one) it's easy to screw something.
-- 
Krzysztof Halasa
