Return-Path: <linux-kernel-owner+w=401wt.eu-S932865AbXH3VH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbXH3VH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXH3VHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:07:06 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:23060 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbXH3VHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:07:01 -0400
Date: Thu, 30 Aug 2007 22:06:08 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, kbuild-devel@lists.sourceforge.net
Subject: Re: CONFIG_HOTPLUG_CPU: kconfig bug?
In-Reply-To: <200708302048.55793.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0708302201240.18935@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708271525400.21853@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0708300235010.1817@scrub.home>
 <Pine.LNX.4.64.0708301319590.32332@blonde.wat.veritas.com>
 <200708302048.55793.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Rafael J. Wysocki wrote:
> On Thursday, 30 August 2007 14:40, Hugh Dickins wrote:
> > 
> > I wonder what config options this might have forced in the past.
> 
> Probably CONFIG_SUSPEND, which was a new option, defaulted to 'y' and
> selected CONFIG_HOTPLUG_CPU indirectly, because CONFIG_SMP was set.

In fact no: although CONFIG_SUSPEND and CONFIG_HIBERNATION were certainly
involved in the logic which arrived at missetting CONFIG_HOTPLUG_CPU,
they were correctly prompted for themselves.

Hugh
