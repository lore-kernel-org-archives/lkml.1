Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYL2KeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYL2KeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYL2KeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:34:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57413 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbYL2KeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:34:06 -0500
Message-ID: <4958A792.9080704@zytor.com>
Date: Mon, 29 Dec 2008 02:33:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers_install.pl: autoconvert asm/inline/volatile to
 __xxx__
References: <1230364498-31620-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1230364498-31620-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> Headers in userspace should be using the __xxx__ form of the asm, inline,
> and volatile keywords.  Since people like to revert these things without
> realizing what's going on, have the headers install step autoconvert these
> keywords.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

volatile?

volatile is a keyword in C90, and anything older than that we're
guaranteed to not be compatible with anyway...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

