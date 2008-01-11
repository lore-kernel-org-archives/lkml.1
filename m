Return-Path: <linux-kernel-owner+w=401wt.eu-S1762344AbYAKRzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762344AbYAKRzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbYAKRyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:54:52 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:51065 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761521AbYAKRyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:54:51 -0500
Date: Fri, 11 Jan 2008 18:54:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, mingo@redhat.com,
       tglx <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: discover_ebda section mismatch
Message-ID: <20080111175450.GD28624@uranus.ravnborg.org>
References: <20080110143214.8be8bb4c.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110143214.8be8bb4c.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 02:32:14PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatches.  discover_ebda() can be __init.
> 
> WARNING: vmlinux.o(.text+0x738a): Section mismatch: reference to .init.data:ebda_addr (between 'discover_ebda' and 'get_model_name')
> WARNING: vmlinux.o(.text+0x73c4): Section mismatch: reference to .init.data:ebda_size (between 'discover_ebda' and 'get_model_name')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
