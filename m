Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXIINlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXIINlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 09:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXIINls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 09:41:48 -0400
Received: from mail96.megamailservers.com ([216.251.36.96]:44133 "EHLO
	mail96.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975AbXIINlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 09:41:47 -0400
X-Authenticated-User: jgeorgas.georgas.ca
Subject: Re: broken ACPI NUMA config option
From: "James C. Georgas" <jgeorgas@georgas.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070908220043.8830512d.randy.dunlap@oracle.com>
References: <1189291899.13467.20.camel@Tachyon.home>
	 <20070908180904.656f3d03.randy.dunlap@oracle.com>
	 <20070908181607.4f36479c.randy.dunlap@oracle.com>
	 <1189309736.13467.77.camel@Tachyon.home>
	 <20070908220043.8830512d.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: Georgas Software Solutions
Date: Sun, 09 Sep 2007 09:41:26 -0400
Message-Id: <1189345287.7365.23.camel@Tachyon.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-09 at 22:00 -0700, Randy Dunlap wrote:
> > For example, you would only need to specify one "select" directive in
> > X86_64_ACPI_NUMA, (i.e. to turn on ACPI_NUMA). The configuration system
> > would then recursively walk up ACPI_NUMA's dependency hierarchy, turning
> > on what it needed.
> 
> That is highly desirable IMO.  Not having that is one of the things
> that makes using 'select' "evil."
> 
> Have you looked at the code and given any thought to implementing this?
> 

I'd like to take a run at it. The only issue I foresee is what to do
about multiple OR dependencies. There are some kconfig options that
depend on at least one of a set of specified dependencies. For example,
is ARCH_SPARSEMEM_ENABLE selectable if only one of NUMA || EXPERIMENTAL
is selected? So do we abort, select one, or select all dependencies?

Maybe I'm misunderstanding the usage of || here though. I'm assuming
inclusive OR.

James
	/\V

