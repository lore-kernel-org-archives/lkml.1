Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbYEPRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbYEPRwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYEPRwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:52:03 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:53050 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755028AbYEPRwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:52:02 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend/Resume bug in PCI layer wrt quirks
Date: Fri, 16 May 2008 10:51:49 -0700
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       Shaohua Li <shaohua.li@intel.com>
References: <20080515070546.6ea9c681@infradead.org> <200805150907.06930.jbarnes@virtuousgeek.org> <200805152151.31936.rjw@sisk.pl>
In-Reply-To: <200805152151.31936.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161051.49919.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2008 12:51 pm Rafael J. Wysocki wrote:
> Some quirks should be called with interrupt disabled, we can't directly
> call them in .resume_early. Also the patch introduces
> pci_fixup_resume_early and pci_fixup_suspend, which matches current
> device core callbacks (.suspend/.resume_early).
>
> TBD: Somebody knows why we need quirk resume should double check if a
> quirk should be called in resume or resume_early. I changed some per my
> understanding, but can't make sure I fixed all.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

I applied this one to linux-next, it should fix some of the problems people 
have been seeing at least...

Jesse
