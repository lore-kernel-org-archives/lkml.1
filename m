Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXL0BRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXL0BRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 20:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXL0BRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 20:17:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56068 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXL0BRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 20:17:31 -0500
Date: Thu, 27 Dec 2007 01:17:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Julia Lawall <julia@diku.dk>,
       tglx@linutronix.de, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/x86: Use offsetof
Message-ID: <20071227011712.GG27894@ZenIV.linux.org.uk>
References: <Pine.LNX.4.58.0712261712450.1185@pc-041.diku.dk> <20071226194718.GB8844@elf.ucw.cz> <4772F972.7070802@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4772F972.7070802@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 05:01:38PM -0800, H. Peter Anvin wrote:

> The right way to do it is:
> 
> 	memset(&info.vm86plus, 0, sizeof info.vm86plus);

If it's just one field _and_ we don't have padding we want to zero out -
certainly...
