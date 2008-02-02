Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbYBBEoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbYBBEoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 23:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbYBBEoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 23:44:17 -0500
Received: from lixom.net ([66.141.50.11]:50990 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbYBBEoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 23:44:17 -0500
Date: Fri, 1 Feb 2008 22:44:46 -0600
From: Olof Johansson <olof@lixom.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build error on PowerPC
Message-ID: <20080202044446.GA14936@lixom.net>
References: <1201866279.6218.187.camel@violet> <20080201232741.GA7853@lixom.net> <1201921027.15090.28.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201921027.15090.28.camel@violet>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 03:57:07AM +0100, Marcel Holtmann wrote:
> Hi Olof,
> 
> > Please define what kernel version and what config you're trying to
> > build.
> 
> it is the latest kernel for Linus' git and the config is kinda obviously
> enabling the awacs.c driver. Anyway, the driver didn't make use of the
> NVRAM call and thus removing that include is perfectly fine. Attached
> patch fixes that issue.

Sure, but it could have been dependent on other options around it (i.e.
nvram-related ones). It's just good habit to include the info, that's
all.

> > Also, please cc linuxppc-dev@ozlabs.org for powerpc issues.
> 
> To be quite honest, it is highly likely that I forget the next time.
> Good that you read LKML :)

Well, sometimes I do, sometimes others do. It just might take longer for
someone to stuble over it. :-)


-Olof

