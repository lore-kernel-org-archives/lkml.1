Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYFAQZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYFAQZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYFAQZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:25:21 -0400
Received: from lazybastard.de ([212.112.238.170]:55229 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYFAQZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:25:20 -0400
Date: Sun, 1 Jun 2008 18:25:00 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Newall <davidn@davidnewall.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Message-ID: <20080601162459.GB13094@logfs.org>
References: <200805311737.58991.arnd@arndb.de> <48419F45.20908@davidnewall.com> <200805312240.50720.arnd@arndb.de> <48423B8A.20505@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48423B8A.20505@davidnewall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 June 2008 15:32:50 +0930, David Newall wrote:
> 
> I've not used unionfs (nor aufs) so I'm not aware of its foibles, but I
> can say that it's the right kind of solution.  Rather than spend effort
> implementing write support for read-only filesystems, why not put your
> time into fixing whatever you see wrong with one or both of those?

There is a strong argument to be made for fixing some problem once
instead of N times.  But when that solution is M times more complicated,
with M being significantly larger than N, said argument becomes rather
weak.

And having looked at unionfs, I claim that your argument is paper-thin.

Jörn

-- 
/* Keep these two variables together */
int bar;
