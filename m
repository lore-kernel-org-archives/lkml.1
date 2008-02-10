Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYBJKvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYBJKvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbYBJKvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:51:09 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33900 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbYBJKvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:51:06 -0500
Date: Sun, 10 Feb 2008 11:50:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Avi Kivity <avi@argo.co.il>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH] make KVM selectable again
Message-ID: <20080210105057.GD10790@uranus.ravnborg.org>
References: <1202590755.14165.11.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202590755.14165.11.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave.
> 
> I've verified that arch/x86/kvm/Kconfig was getting run by putting some
> comments in it.  It seems to me like just putting:
> 
> 	config HAVE_KVM
> 	       bool
> 
> isn't letting anything come into my .config at all.  I'm not sure why we
> do that, and then have:
> 
> 	select HAVE_KVM
> 
> in arch/x86/Kconfig.

See rationale in Documentation/kbuild/kconfig-language.txt - last chapter.
In this case the select was just placed wrongly.

	Sam
