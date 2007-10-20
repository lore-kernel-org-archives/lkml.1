Return-Path: <linux-kernel-owner+w=401wt.eu-S1752283AbXJUCgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbXJUCgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 22:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbXJUCgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 22:36:48 -0400
Received: from xenotime.net ([66.160.160.81]:58664 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750826AbXJUCgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 22:36:47 -0400
Date: Sat, 20 Oct 2007 14:56:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Henrik Carlqvist <hc1@poolhem.se>, linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-Id: <20071020145652.3696de40.rdunlap@xenotime.net>
In-Reply-To: <20071020191700.GB8774@uranus.ravnborg.org>
References: <200710201257.55616.nick@ukfsn.org>
	<20071020144238.4f258c8c.hc1@poolhem.se>
	<20071020191700.GB8774@uranus.ravnborg.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007 21:17:00 +0200 Sam Ravnborg wrote:

> On Sat, Oct 20, 2007 at 02:42:38PM +0200, Henrik Carlqvist wrote:
> > I think there is a need for Kconfig to specify that a functionality could
> > be built as a module or not built at all.
> 
> I assume
> 	depends on MODULES
> 
> should do the trick.

Some modules use (e.g.)
	depends on PCMCIA and m

but using MODULES does make more sense to me.

---
~Randy
