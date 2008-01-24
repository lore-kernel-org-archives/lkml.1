Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYAXRYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYAXRYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYAXRYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:24:41 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48557 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYAXRYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:24:39 -0500
Subject: Re: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API
From: Dave Hansen <haveblue@us.ibm.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>, Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <4798C664.1040409@fr.ibm.com>
References: <478DFF8F.9030006@openvz.org> <20080123205930.GA5233@ucw.cz>
	 <4798C664.1040409@fr.ibm.com>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 09:24:34 -0800
Message-Id: <1201195474.8329.38.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-24 at 18:09 +0100, Cedric Le Goater wrote:
> yes but we would need more something like  : 
> 
>  long sys_clone64(unsigned long flags_high, unsigned long flag_low)
> 
> if we want the syscall to be supported on 32bit arch. clone2 is also 
> being used on ia64 already.

Did we decide not to do something with a variable number of arguments?

	sys_clonefoo(unsigned long *flags, int len);

-- Dave

