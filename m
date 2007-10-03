Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbXJCSRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbXJCSRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbXJCSRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:17:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbXJCSRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:17:30 -0400
Date: Wed, 3 Oct 2007 19:17:22 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, paul.moore@hp.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071003181722.GL8181@ftp.linux.org.uk>
References: <20071003051254.GH8181@ftp.linux.org.uk> <287091.73995.qm@web36604.mail.mud.yahoo.com> <20071003175237.GK8181@ftp.linux.org.uk> <20071003191735.4d92c593@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003191735.4d92c593@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 07:17:35PM +0100, Alan Cox wrote:
> > Absolute paths in that kind of thing are _wrong_.  You know where the things
> > are on your fs.  You don't know if anything else will be visible, let alone
> > whether it will be at the same place in all chroots or namespaces.  And no,
> > you _can't_ make sure that fs is visible only in one place.  No fs can or
> > has any business even trying.
> 
> What I don't understand here is why we need the hacks when we already
> support sufficient mount magic to give each login session its own
> private /tmp ?

Presumably his context can change within a login session?  If not, it's
indeed simply worthless, absolute paths or not.
