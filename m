Return-Path: <linux-kernel-owner+w=401wt.eu-S1761662AbYAKRyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662AbYAKRyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbYAKRyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:54:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50941 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759348AbYAKRyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:54:32 -0500
Date: Fri, 11 Jan 2008 18:54:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: tpm@selhorst.net, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] tpm: infineon section mismatch
Message-ID: <20080111175427.GC28624@uranus.ravnborg.org>
References: <20080110143158.28f1d591.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110143158.28f1d591.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 02:31:58PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch by making the driver template variable name
> match one of the whitelisted variable names in modpost.
> 
> WARNING: vmlinux.o(.data+0x7a9e8): Section mismatch: reference to .init.text:tpm_inf_pnp_probe (between 'tpm_inf_pnp' and 'cn_idx')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
