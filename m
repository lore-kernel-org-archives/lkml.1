Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616Ab0AYMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0AYMdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 07:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300Ab0AYMdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 07:33:16 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58169 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab0AYMdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 07:33:15 -0500
X-Sasl-enc: Y2n/nrEsh4o4L+MIGeSG96HbVZqjCIoWT7ILlnU5IWSa 1264422794
Date: Mon, 25 Jan 2010 10:33:11 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: High pitch noise when ACPI processor module is loaded.
Message-ID: <20100125123311.GC3182@khazad-dum.debian.net>
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan>
 <9883.1264397678@localhost>
 <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Justin Piszcz wrote:
> So the question remains, is it possible to utilize turbo boost (in Linux)
> without the high pitch noise from the ACPI processor module?

Well, I am tempted to say you should consider getting a higher quality
motherboard (or, if it is just yours that sing, get it replaced on warranty
as that would mean you got one with bad components).

That said, if Windows can get that motherboard to shut up, so should Linux.
You just need to find the right knob to push that will make the power draw
behaviour more like whatever Windows is doing.

The first good bet is to limit core C-state depth, e.g, to C3 (instead of
C5/C6), and if thet doesn't work, to C2.  After that, you can try limiting
package C-states if your BIOS will let you (I don't know if we can do that
distinction in Linux right now... do we?), play with cpufreq limiting the
core frequency changes, etc.

And of course, try all scheduler frequencies, with and without NO_HZ.

What motherboard is this?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
