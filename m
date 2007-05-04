Return-Path: <linux-kernel-owner+w=401wt.eu-S1422756AbXEDHFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422756AbXEDHFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422770AbXEDHFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:05:37 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:33383
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422756AbXEDHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:05:36 -0400
Date: Fri, 4 May 2007 09:08:40 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Power Management: use mutexes instead of semaphores
Message-ID: <20070504070840.GD3234@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
	linux-kernel@vger.kernel.org
References: <20070427083857.GB4213@traven> <20070427084322.GC4213@traven> <20070503225432.97dad06e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503225432.97dad06e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, May 03, 2007 at 10:54:32PM -0700 Andrew Morton ha dit:

> On Fri, 27 Apr 2007 10:43:22 +0200 Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:
> 
> > the Power Management code uses semaphores as mutexes. use the mutex
> > API instead of the (binary) semaphores
> 
> I know it's a little thing, but given a choice between
> 
> a) changelogs which use capital letters and fullstops and
> 
> b) changelogs which do not,
> 
> I think a) gives a better result.

thanks for your suggestion, i'll take it into account for future patches
 
> I note that none of these patches added a #include <linux/mutex.h>.  Each C
> file which uses mutexes should do that, rather than relying upon accidental
> nested includes.  I hope you're checking for that.

initially i added the include line (i think at least one patch still
contains it), but then i realized that in most cases the original code
doesn't include semaphore.h and i (mis-)interpreted that it should be
handled the same way (relying upon nested includes) for mutexes. 

do you want me to send you a version of the patches containing the
include?

regards

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      The assumption that what currently exists must necessarily
        exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
