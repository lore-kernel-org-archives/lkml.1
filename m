Return-Path: <linux-kernel-owner+w=401wt.eu-S1422903AbXCOPbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422903AbXCOPbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422905AbXCOPbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:31:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422903AbXCOPbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:31:05 -0400
Message-ID: <45F966B4.8070607@redhat.com>
Date: Thu, 15 Mar 2007 11:31:00 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Bug 8040] Hang before INIT when CONFIG_HIGHMEM4G=y [Fix CONFIG_COMPAT_VDSO]
 <- Bad
References: <200703141013.l2EADP6c027144@fire-2.osdl.org>  <20070314041710.770708c4.akpm@linux-foundation.org> <6bffcb0e0703140430i2202f14dw1681d5c70c1d4e28@mail.gmail.com> <loom.20070314T131349-236@post.gmane.org> <loom.20070314T184515-284@post.gmane.org>
In-Reply-To: <loom.20070314T184515-284@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Leroy van Logchem wrote:
> 
> Bisecting went well, after 13 compiles this commit was found:
> 
> a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f is first bad commit
> commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f
> Author: Roland McGrath <roland@redhat.com>
> Date:   Fri Jan 26 00:56:46 2007 -0800
> 
>     [PATCH] Fix CONFIG_COMPAT_VDSO
>     

So you do have CONFIG_COMPAT_VDSO in your config, then?

