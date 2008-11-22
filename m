Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYKVJly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYKVJly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYKVJlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:41:46 -0500
Received: from kandzendo.ru ([195.178.208.66]:59986 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbYKVJlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:41:45 -0500
Date: Sat, 22 Nov 2008 12:41:44 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Newall <davidn@davidnewall.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081122094144.GB12543@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de> <4927B0D5.4020907@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4927B0D5.4020907@davidnewall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 05:42:21PM +1030, David Newall (davidn@davidnewall.com) wrote:
> Why not require local access to use the same mechanism as remote, i.e.
> by "network mounting" the data on the local machine, too.  That way
> there's no confusion over where the change originated nor who's copy
> must be invalidated.

There is always a possibility that some application will access given
data directly and not via mounted partition, plus I have to patch
server's kernel with out of the tree modules, so intestead I could
implement lsm-based module to catch access and embed cache coherency
protocol there. Inotify in this case is the simplest approach.

-- 
	Evgeniy Polyakov
