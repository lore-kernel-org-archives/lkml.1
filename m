Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYLJWxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYLJWxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYLJWxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:53:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501AbYLJWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:53:21 -0500
Date: Wed, 10 Dec 2008 14:52:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for December 10
Message-Id: <20081210145226.8a174e68.akpm@linux-foundation.org>
In-Reply-To: <20081210164659.9ebb8158.sfr@canb.auug.org.au>
References: <20081210164659.9ebb8158.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 16:46:59 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (patches at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/)

This tree breaks poweroff on my x86_64 test box.  `halt -pfn' does all
the usual things, but the machine doesn't turn off.

config: http://userweb.kernel.org/~akpm/config-akpm2.txt
dmesg: http://userweb.kernel.org/~akpm/dmesg-akpm2.txt

Any suggestions which don't include the word "bisect" would be most welcome.
