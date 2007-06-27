Return-Path: <linux-kernel-owner+w=401wt.eu-S1763541AbXF0WpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763541AbXF0WpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761669AbXF0WpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:45:07 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:36173 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbXF0WpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:45:05 -0400
Date: Thu, 28 Jun 2007 00:46:24 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070627224623.GO13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com> <1182855427.12109.203.camel@pmac.infradead.org> <20070626170622.GA13886@enneenne.com> <1182879520.3263.19.camel@shinybook.infradead.org> <20070627101449.GH13886@enneenne.com> <1182939510.6409.17.camel@pmac.infradead.org> <20070627125802.GI13886@enneenne.com> <1182960660.1170.12.camel@pmac.infradead.org> <20070627174537.GM13886@enneenne.com> <1182966588.1170.28.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182966588.1170.28.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 06:49:48PM +0100, David Woodhouse wrote:
> 
> Looks better. All I can find to complain about is the fact that you
> return whatever copy_from_user() returns. Don't -- that's the number of
> bytes left to copy. It should be if (copy_from_user(..)) return -EFAULT;

Ok, I'll fix it.

Just last question: I still don't well understand where I should
declare the new compat_sys_time_pps_fetch() syscall... it's
automagically defined by the system when CONFIG_COMPAT is enabled? :-o

Thanks for your help,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
