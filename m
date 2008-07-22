Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYGVUhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYGVUhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYGVUhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:37:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58378 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYGVUg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:36:59 -0400
Date: Tue, 22 Jul 2008 13:36:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] kernel-doc: handle/strip __init
Message-Id: <20080722133605.34a399a8.randy.dunlap@oracle.com>
In-Reply-To: <20080627210521.GC29245@uranus.ravnborg.org>
References: <20080619160329.1a4fe917.randy.dunlap@oracle.com>
	<20080627210521.GC29245@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 23:05:21 +0200 Sam Ravnborg wrote:

> On Thu, Jun 19, 2008 at 04:03:29PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > cc: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Handle __init in functions with kernel-doc notation by stripping the
> > __init away from the output doc.  This is already being done for
> > "__devinit".  This patch fixes these kernel-doc error/aborts:
> 
> Applied

Hi Sam,

This patch is now needed so that "make *docs" does not fail.

Will you have Linus pull your tree soon or shall I send it separately?

Thanks,
---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
