Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZKIOu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZKIOu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZKIOu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:50:59 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:60835 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbZKIOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:50:58 -0500
Date: Mon, 9 Nov 2009 15:50:56 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Clemens Ladisch <clemens@ladisch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-ID: <20091109145056.GB14091@buzzloop.caiaq.de>
References: <4AF7D439.4030305@ladisch.de>
 <20091109091044.GX29442@buzzloop.caiaq.de>
 <4AF7DDC1.4090006@ladisch.de>
 <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
 <4AF7FC64.6030904@ladisch.de>
 <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 11:46:00AM +0000, Alan Cox wrote:
> > The justification from Daniel's original patch was:
> > | For embedded systems, the blinking cursor at startup time can be
> > | annoying and unintended.
> > 
> > Would a simple "Disable cursor by default" switch more acceptable?
> 
> Well I guess you could just make the default cursor define a variable and
> mark it MODULE_PARAM ?

I had that previously and the response was that there is no reason to
define that setting per-boot process, as it is rather unlikely that you
want to change it from one boot to the next. Hence, it should be set at
compile time.

And even if the cursor behaviour is changable at runtime, I don't see
why it shouldn't have a selectable compile time default. Which is what
the patch adds.

Daniel
