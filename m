Return-Path: <linux-kernel-owner+w=401wt.eu-S933487AbXBEVlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbXBEVlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933480AbXBEVlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:41:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37167 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478AbXBEVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:41:24 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070205215007.0820edea@localhost.localdomain>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	 <1170710272.29759.894.camel@pmac.infradead.org>
	 <20070205215007.0820edea@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 21:41:09 +0000
Message-Id: <1170711669.29759.913.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 21:50 +0000, Alan wrote:
> > No, you're thinking of something else. The use of 'select' just turns
> > the problem backwards -- if _every_ SCSI hostadapter were to 'select
> > SCSI' instead of depending on it, then I'd have to say 'n' to every damn
> > one of them instead of being able to just say 'n' to SCSI as I can at
> > the moment.
> 
> Tools issue. You want a "really de-select right now" button  

That's a useful suggestion actually -- one answer to this bogus
proliferation of 'select' is to hack the tools so that they treat
occurrences of 'select' referring to a _visible_ option as the
dependencies which they _should_ have been, rather than this silly new
behaviour.

-- 
dwmw2

