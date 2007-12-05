Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbXLOHzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbXLOHzm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXLOHzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:55:20 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2061 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752815AbXLOHzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:55:18 -0500
Date: Wed, 5 Dec 2007 16:47:41 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Subject: Re: vcsa and big endian
Message-ID: <20071205164740.GB4756@ucw.cz>
References: <20071209224348.GA25292@implementation> <20071209225039.GB25047@implementation>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071209225039.GB25047@implementation>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-09 23:50:39, Samuel Thibault wrote:
> Samuel Thibault, le Sun 09 Dec 2007 23:43:49 +0100, a écrit :
> > On big endian machines, /dev/vcsa stores text/attribute bytes in big
> > endian order, while it stores them in little endian order on little
> > endian machines.  Is that expected?
> 
> It looks like ggi considers this as normal.  In any case, the vcsa
> manual page should probably be made more clear ("but including
> attributes" -> "but using unsigned shorts that include attributes" for
> instance).

I'd say you need stronger warning than that, "warning, vcsa is in host
byte endianity" or something.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
