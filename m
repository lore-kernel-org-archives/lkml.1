Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbYEORKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbYEORKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYEORKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:10:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYEORKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:10:05 -0400
Date: Thu, 15 May 2008 14:10:03 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH][PCI]: Introduce pci_find_capability_cached and make
	MSI use it
Message-ID: <20080515171003.GF14846@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-rt-users@vger.kernel.org
References: <20080515160426.GD14846@ghostprotocols.net> <20080515170407.GM9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515170407.GM9921@parisc-linux.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 15, 2008 at 11:04:07AM -0600, Matthew Wilcox escreveu:
> On Thu, May 15, 2008 at 01:04:26PM -0300, Arnaldo Carvalho de Melo wrote:
> > 	So I implemented pci_find_capability_cached and made MSI use it
> > for good measure, please consider applying.
> 
> As I told you on IRC, this is just the MSI code being complete crap.
> It should be caching the offset itself.  We shouldn't have this extra
> array in the struct pci_dev just because MSI is broken.

Well, we can certainly do that, its just that I did this first and
thought that perhaps there could be some other users, but I see that 44
extra bytes per pci_dev can be a pain if the only one to reap benefits
is MSI, can't you think of any other users? I couldn't detect any so far
in my admitedly limited testing.

- Arnaldo
