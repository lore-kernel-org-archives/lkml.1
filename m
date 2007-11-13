Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXKMFjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXKMFjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXKMFi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:38:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbXKMFi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:38:57 -0500
Date: Mon, 12 Nov 2007 21:38:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: casey@schaufler-ca.com
Cc: torvalds@linux-foundation.org, method@manicmethod.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/2] Version 11 (2.6.24-rc2) Smack: Simplified Mandatory
 Access Control Kernel
Message-Id: <20071112213843.b52ec6b2.akpm@linux-foundation.org>
In-Reply-To: <4733E6B4.8010108@schaufler-ca.com>
References: <4733E6B4.8010108@schaufler-ca.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Nov 2007 20:48:52 -0800 Casey Schaufler <casey@schaufler-ca.com> wrote:

> Smack is the Simplified Mandatory Access Control Kernel.

This ran afoul of
http://userweb.kernel.org/~akpm/mmotm/broken-out/vfs-security-rework-inode_getsecurity-and-callers-to.patch

Until that patch gets merged we'll need to run two smack patches: one
against mainline and one which updates smack to incorporate that patch's
API changes, please.

