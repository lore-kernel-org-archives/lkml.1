Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZG0LE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZG0LE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZG0LEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:04:25 -0400
Received: from mail-a03.ithnet.com ([217.64.83.98]:40796 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754337AbZG0LEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:04:25 -0400
X-Sender-Authentication: net64
Date: Mon, 27 Jul 2009 13:04:20 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Rientjes" <rientjes@google.com>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: [Bug #13648] nfsd: page allocation failure
Message-Id: <20090727130420.1514cf5c.skraw@ithnet.com>
In-Reply-To: <H5-1lZIIeYK.A.HXG.DXObKB@chimera>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
	<H5-1lZIIeYK.A.HXG.DXObKB@chimera>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 22:45:33 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13648
> Subject		: nfsd: page allocation failure
> Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
> Date		: 2009-06-22 12:08 (35 days old)
> References	: http://lkml.org/lkml/2009/6/22/309
> 		  http://marc.info/?l=linux-kernel&m=124748600712853&w=4
> 

This is no regression between 2.6.29 and 2.6.30.
In fact we could reproduce the problem with kernel versions:

2.6.27.26 < X <= 2.6.30.3

(Meaning 2.6.27.26 is the last one _not_ showing the problem).

-- 
Regards,
Stephan

