Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbXKFPj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbXKFPj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXKFPjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:39:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbXKFPjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:39:48 -0500
Date: Tue, 6 Nov 2007 07:39:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
In-Reply-To: <20071106080637.GB26163@stusta.de>
Message-ID: <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
 <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu>
 <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
 <20071106080637.GB26163@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Nov 2007, Adrian Bunk wrote:
> 
> How do we get the information about the character encoding of the string 
> to be parsed into the kernel?

I really would expect that kernel strings don't have an encoding. They're 
just C strings: a NUL-terminated stream of bytes.

		Linus
