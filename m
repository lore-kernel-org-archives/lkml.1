Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0BHXjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:39:08 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37420 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab0BHXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:39:06 -0500
X-Sasl-enc: FINRvortpS6t+LF3evX1z8pIYtLofUBOyXKxWlrGzT+r 1265672343
Date: Sun, 7 Feb 2010 18:05:06 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] thinkpad-acpi: fix link error to include sound arch
Message-ID: <20100207200506.GA25736@khazad-dum.debian.net>
References: <1263820516-6924-1-git-send-email-hagen@jauu.net> <20100119145108.GD2668@khazad-dum.debian.net> <73f3c62cccfd75cb045a352320346c26@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73f3c62cccfd75cb045a352320346c26@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010, Hagen Paul Pfeifer wrote:
> On Tue, 19 Jan 2010 12:51:08 -0200, <hmh@hmh.eng.br> wrote:
> > Can you describe the problem in more detail?  That will save me precious
> > time, as I am rather overworked right now...
> 
> If you build the sound as a module and thinkpad as a build-in component
> the linker will complain about missing symbols. So the right fix may

This is not supposed to be possible anymore, and in fact, I can't force
that breakage to happen in 2.6.33-rc6.

> be a patch that 1) enforces the sound component to be build static or
> to enforces thinkpad apic to be build as a module. Another way 2) is

Currently, the Kconfig disables ALSA support for thinkpad-acpi static
and ALSA as module, but allows static-static or module-module.

> Any other ideas Henrique?

No, you're correct, but the fix was already in its way to mainline when
you sent your report.  I took some time to try to break it today, just
in case there was something I missed.

What kernel was giving you trouble? I still need to fix the backports in
the thinkpad-acpi git tree, maybe it was one of them?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
