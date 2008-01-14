Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYANB5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYANB5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYANB5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:57:25 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39162 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbYANB5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:57:24 -0500
X-Sasl-enc: R75PnlRWXIJJPfCRx+sXpYA8VaDRP6i9SVJDcSc6a7lN 1200275842
Date: Sun, 13 Jan 2008 23:57:18 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Lenovo ThinkPads need acpi_osi="Linux"
Message-ID: <20080114015718.GA15124@khazad-dum.debian.net>
References: <20080112022348.GC27524@khazad-dum.debian.net> <200801120416.08631.lenb@kernel.org> <20080113165801.GA4132@ucw.cz> <20080113234129.GE10693@khazad-dum.debian.net> <20080114003553.GA1698@srcf.ucam.org> <20080114015009.GA2317@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114015009.GA2317@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008, Matthew Garrett wrote:
> On Mon, Jan 14, 2008 at 12:35:54AM +0000, Matthew Garrett wrote:
> > No. This breaks on the R50e, at least - I suspect it'd also have 
> > problems on any nvidia based machines, but I don't have one to hand at 
> > the moment. It can be set at runtime already.
> 
> Just to clarify this further, in the relatively near-term future we're 
> not going to want the low-level ACPI code to do anything video-related 
> on a lot of hardware. The in-kernel modesetting code for Intel machines 
> will be able to handle this significantly more effectively.

Yeah, but we have a ton of machines (thinkpads among them) with ATI, and
other GPUs.

Whitelists would need to be reasonably specific, anyway (not "all
thinkpads"), so it just means "don't do it on certain R50e", or whatever.

It is no easy problem, and the fix might not be as simple as one could wish,
either.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
