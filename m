Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbXHaXX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbXHaXX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 19:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXHaXXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 19:23:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:41891 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXHaXXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 19:23:18 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/4] 2.6.23-rc4: known regressions
Date: Fri, 31 Aug 2007 18:01:16 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Michael Sedkowski <sedmich@gmail.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, alsa-devel@alsa-project.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       "Ivan N. Zlatev" <contact@i-nz.net>, Thomas Meyer <thomas@m3y3r.de>,
       dth <dth@dth.net>
References: <46D58CC6.4020605@googlemail.com> <46D59052.6040609@googlemail.com>
In-Reply-To: <46D59052.6040609@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311801.16899.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> ACPI
> 
> Subject         : 2.6.23-rc4: maxcpus still broken
> References      : http://lkml.org/lkml/2007/8/28/87
> Last known good : ?
> Submitter       : Alexey Dobriyan <adobriyan@sw.ru>
> Caused-By       : Len Brown <len.brown@intel.com>
>                   commit 61ec7567db103d537329b0db9a887db570431ff4
> Handled-By      : Len Brown <len.brown@intel.com>
> Status          : problem is being debugged
> 

Hugh debugged and fixed this one, and it is checked into 2.6.23-rc4-git3
62e6f1e8bb7c48c02b8bdb3085c5f6365682149b 
fix maxcpus=1 oops in show_stat()
    

thanks,
-Len
