Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbXJRFKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbXJRFKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXJRFKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:10:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38220 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbXJRFKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:10:36 -0400
Date: Thu, 18 Oct 2007 06:10:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 8 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071018051031.GN8181@ftp.linux.org.uk>
References: <47158CE4.30706@schaufler-ca.com> <20071018045705.GM8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018045705.GM8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 05:57:05AM +0100, Al Viro wrote:
> On Tue, Oct 16, 2007 at 09:17:40PM -0700, Casey Schaufler wrote:

> Think what happens if CPU1 adds to list and CPU2 sees write to smk_known
> *before* it sees write to ->smk_next.  We see a single-element list and
> we'll be lucky if that single entry won't be FUBAR.

While we are at it, what protects smack_cipso_count?
