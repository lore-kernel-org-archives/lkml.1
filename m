Return-Path: <linux-kernel-owner+w=401wt.eu-S1751159AbZKXFAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbZKXFAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbZKXFAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:00:11 -0500
Received: from tundra.namei.org ([65.99.196.166]:44212 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZKXFAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:00:10 -0500
Date: Tue, 24 Nov 2009 15:59:00 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>, Steve Grubb <sgrubb@redhat.com>,
       linux-security-module@vger.kernel.org,
       Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH] remove CONFIG_SECURITY_FILE_CAPABILITIES compile
 option
In-Reply-To: <20091123222130.GA11325@us.ibm.com>
Message-ID: <alpine.LRH.2.00.0911241558420.30118@tundra.namei.org>
References: <20091123222130.GA11325@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Serge E. Hallyn wrote:

> So this patch removes the SECURITY_FILE_CAPABILITIES compile
> option.  It drops the kernel size by about 50k over the stock
> SECURITY_FILE_CAPABILITIES=y kernel, by removing the
> cap_limit_ptraced_target() function.
> 
> Changelog:
> 	Nov 20: remove cap_limit_ptraced_target() as it's logic
> 		was ifndef'ed.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: Andrew G. Morgan" <morgan@kernel.org>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
