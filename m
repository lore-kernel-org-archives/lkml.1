Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXF1OMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXF1OMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXF1OMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:12:38 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:15126 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbXF1OMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:12:37 -0400
Message-ID: <4683C1C4.3000108@suse.de>
Date: Thu, 28 Jun 2007 23:12:20 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: seife@suse.de, rjw@sisk.pl, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org, suspend-devel@lists.sourceforge.net
Subject: Re: [RFC] get rid of CONFIG_DISABLE_CONSOLE_SUSPEND
References: <20070628135108.GA1810@elf.ucw.cz>
In-Reply-To: <20070628135108.GA1810@elf.ucw.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> What about this? (Only compile tested, but looks pretty obvious to
> me). Something like this should get us rid of ugly option, and still
> solve debugging problems... Hmmm?

Violent agreement from me.  Not taking down serial console would help a
lot too.  Storing dmesg from the image-loading kernel during resume from
hibernation would be another nice addition.

-- 
tejun
