Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbXCLXyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbXCLXyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbXCLXyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:54:54 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:40250 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbXCLXyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:54:53 -0400
Date: Tue, 13 Mar 2007 00:54:52 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Kirill Korotaev <dev@sw.ru>, containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelianov <xemul@sw.ru>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
Message-ID: <20070312235452.GB11578@MAIL.13thfloor.at>
Mail-Followup-To: Dave Hansen <hansendc@us.ibm.com>,
	Kirill Korotaev <dev@sw.ru>, containers@lists.osdl.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Paul Menage <menage@google.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Pavel Emelianov <xemul@sw.ru>
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru> <m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru> <1173718208.11945.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173718208.11945.54.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 09:50:08AM -0700, Dave Hansen wrote:
> On Mon, 2007-03-12 at 19:23 +0300, Kirill Korotaev wrote:
> > 
> > For these you essentially need per-container page->_mapcount counter,
> > otherwise you can't detect whether rss group still has the page 
> > in question being mapped in its processes' address spaces or not. 

> What do you mean by this?  You can always tell whether a process has a
> particular page mapped.  Could you explain the issue a bit more.  I'm
> not sure I get it.

OpenVZ wants to account _shared_ pages in a guest
different than separate pages, so that the RSS
accounted values reflect the actual used RAM instead
of the sum of all processes RSS' pages, which for
sure is more relevant to the administrator, but IMHO
not so terribly important to justify memory consuming
structures and sacrifice performance to get it right

YMMV, but maybe we can find a smart solution to the
issue too :)

best,
Herbert

> -- Dave
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
