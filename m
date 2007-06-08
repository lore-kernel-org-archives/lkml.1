Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbXFHS7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbXFHS7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXFHS7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:59:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXFHS7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:59:30 -0400
Message-ID: <4669A70A.5010906@redhat.com>
Date: Fri, 08 Jun 2007 14:59:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Kyle McMartin <kyle@canonical.com>,
       Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Size of kernel modules
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de> <20070608034421.GM26717@fattire.cabal.ca> <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2007 08:40 AM, Robert P. J. Day wrote:
> 
>   # make INSTALL_MOD_STRIP=1 modules_install
> 
> that makes a *huge* difference in the size of the installed modules,
> as i learned when i first ran across this on my fedora core system.
> 

learn how to use rpmbuild:

http://fedoraproject.org/wiki/Docs/CustomKernel

You can use --with/--without to build only what you want.
See the top of the specfile for details.
