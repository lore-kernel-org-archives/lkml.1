Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZABPZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZABPZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZABPZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:25:11 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:41744 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751141AbZABPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:25:10 -0500
Subject: Re: [PATCH] Update of Documentation/ (VM sysctls)
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, comandante@zaralinux.com, bb@ricochet.net,
       Rik van Riel <riel@nl.linux.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <495D9222.1060306@oracle.com>
References: <20081231212615.12868.97088.stgit@hermosa.site>
	 <495D9222.1060306@oracle.com>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Fri, 02 Jan 2009 08:25:01 -0700
Message-Id: <1230909901.3470.242.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-01 at 20:03 -0800, Randy Dunlap wrote:
> Peter W Morreale wrote:

> > It assumes that patch: http://lkml.org/lkml/2008/12/31/219 has been applied.
> > This is probably wrong since that patch is still being reviewed and not
> > officially accepted as of this patch.  Not sure how to handle this at
> > all.  
> 
> Yes, this patch should be done first/regardless of your other (pending) patch.
> 

Wait a sec...  

There is a patch interdependency here.

This patch includes the text for the two proposed sysctls.  If they are
rejected, then this help text will refer to two non-existent sysctls.
Minor issue compared to:

The pdflush sysctl patch was respun to include adding text (against the
current vm.txt) for the new sysctls.  So that patch will fail to apply
should this patch be added first. 

See what I mean? So what do I do?

Thx,
-PWM

