Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbXJaNG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbXJaNG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXJaNGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:06:41 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:55496 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbXJaNGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:06:40 -0400
Date: Wed, 31 Oct 2007 13:06:22 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: veerasena reddy <veerasena_b@yahoo.co.in>
Cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: porting KGDB onto MIPS24K processor running linux-2.6.18.8
Message-ID: <20071031130622.GD14187@linux-mips.org>
References: <245251.43610.qm@web8413.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <245251.43610.qm@web8413.mail.in.yahoo.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 03:32:58PM +0530, veerasena reddy wrote:

> I would like to port KGDB on MIPS24K target processor which is running linux-2.6.18.8 kernel.
> Could you please guide me, where can I get the appropriate KGDB patch for 2.6.18.8 kernel?

Generic MIPS KGDB support is in the kernel.  You will need to add two
functions getDebugChar and putDebugChar to do the debug I/O plus whatever
initialization the KGDB serial interface needs and have your platform
set SYS_SUPPORTS_KGDB in Kconfig to indicate it actually supports KGDB.

  Ralf
