Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZAMMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZAMMYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZAMMYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:24:01 -0500
Received: from corega.com.ru ([195.178.208.66]:60857 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZAMMYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:24:01 -0500
Date: Tue, 13 Jan 2009 15:23:56 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       greg@kroah.com
Subject: Re: ANDROID low memory killer register (was Linux killed Kenny, bastard!)
Message-ID: <20090113122356.GB25011@ioremap.net>
References: <496C73DE.3030600@wpkg.org> <20090113121038.3410de28@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113121038.3410de28@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 12:10:38PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> I believe they are related in the sense that both of them are
> unneccessary and should not make the final kernel...
> 
> The /proc../oom_adj interface is again sufficient for this.

Besides the fact that it will unlikely to work the way you expect, since
oom adjustment is racy and may be too late, or not happend at all...

Alan, please try to apply this to practice and then you will suddenly
find that it would be really great to have a different method, which
will just work.

-- 
	Evgeniy Polyakov
