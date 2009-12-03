Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZLCUky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZLCUky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbZLCUkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:40:53 -0500
Received: from soto.provo.novell.com ([137.65.250.214]:43519 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZLCUkw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-pmullaney@novell.com;5:1>);
	Thu, 3 Dec 2009 15:40:52 -0500
Message-Id: <4B17BFE5020000C70007C8C6@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 03 Dec 2009 13:40:53 -0700
From: "Patrick Mullaney" <pmullaney@novell.com>
To: <arnd@arndb.de>
Cc: <bridge@lists.linux-foundation.org>,
       <alacrityvm-devel@lists.sourceforge.net>, <kaber@trash.net>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/3] macvlan: allow in-kernel modules to create and
	 manage macvlan devices
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-27 at 23:14 +0100, Arnd Bergmann wrote:
> On Friday 13 November 2009, Patrick Mullaney wrote:
> > 
> > The macvlan driver didn't allow for creation/deletion of devices
> > by other in-kernel modules. This patch provides common routines
> > for both in-kernel and netlink based management. This patch
> > also enables macvlan device support for gro for lower level
> > devices that support gro.
> 
> I wonder if doing this way round is a good idea, why don't
> you just use netlink to set up the endpoint device like
> the current macvlan and macvtap do? I think doing it consistently
> for all backends would be a significant advantage.

sorry for the late response - I'm thinking about re-implementing
this along the lines that you are talking about. Especially in light
of your new configuration options. The reason(probably short sighted)
for the previous approach was that the creation step was already being
handled in our venet driver(but it doesn't have to be).

Thanks for the suggestion.
Patrick

> 
> 	Arnd <><

