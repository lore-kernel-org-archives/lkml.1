Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab0BES56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:57:58 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:50090 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933764Ab0BES54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:57:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bvQVFNnKcI9DZw3C1hKZJIBsFOdTIydDiqhr0DuNtkrCJfG2zJJ7LVDo4KFxuTlVi20DLbxi6pXHYl2DTPbJNZ7d70cwyy4wEb40RnnNU+xTkiAIRyO2mQLBd1eTgVxU;
Date: Fri, 5 Feb 2010 10:57:08 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "o. meijer" <meijer.o@gmail.com>,
       "Thorsten Leemhuis" <fedora@leemhuis.info>
Subject: Re: [Bug #14997] Closing and re-opening the lid does not reactivate
 the backlight
Message-ID: <20100205105708.4b8b13e6@jbarnes-piketon>
In-Reply-To: <de962C6zBxL.A.X6E.lFiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.X6E.lFiZLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Feb 2010 01:43:18 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14997
> Subject		: Closing and re-opening the lid does not
> reactivate the backlight Submitter	: o. meijer
> <meijer.o@gmail.com> Date		: 2010-01-06 15:38 (26 days
> old)

Just updated this one as well.  Since it sounds easily reproducible it
would be good to get a bisect.  We haven't changed backlight handling,
but it's likely the lid changes make X handle things differently...

-- 
Jesse Barnes, Intel Open Source Technology Center
