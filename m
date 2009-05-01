Return-Path: <linux-kernel-owner+w=401wt.eu-S1765000AbZEAPCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765000AbZEAPCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932692AbZEAPBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:01:14 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60466 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932682AbZEAPBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:01:13 -0400
Date: Fri, 1 May 2009 11:00:12 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: David Howells <dhowells@redhat.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 5/6] mn10300: use new macros for .data.init_task.
In-Reply-To: <11779.1241189179@redhat.com>
Message-ID: <alpine.DEB.1.10.0905011048420.10966@vinegar-pot.mit.edu>
References: <1241135661-9147-6-git-send-email-tabbott@mit.edu> <1241135661-9147-1-git-send-email-tabbott@mit.edu> <1241135661-9147-2-git-send-email-tabbott@mit.edu> <1241135661-9147-3-git-send-email-tabbott@mit.edu> <1241135661-9147-4-git-send-email-tabbott@mit.edu>
 <1241135661-9147-5-git-send-email-tabbott@mit.edu>  <11779.1241189179@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, David Howells wrote:

> Tim Abbott <tabbott@MIT.EDU> wrote:
> 
> > .data.init_task should not need a separate output section; this change
> > moves it into the .data section.
> 
> Hmmm...  This causes the kernel I'm building to make an extra page of RAM into
> dead space.

I would try reversing the order of the things inside the .data output 
section, since the stuff after .data at the end of this patch series is 
page-aligned, while the stuff before .data isn't.

	-Tim Abbott


