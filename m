Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYD2BaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYD2BaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYD2BaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:30:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYD2B37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:29:59 -0400
Message-ID: <48167A07.4000305@kernel.org>
Date: Mon, 28 Apr 2008 18:29:43 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu>
In-Reply-To: <20080428230524.GK8474@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Is this really needed Adrian ? I mean, everyone reads iso-8859-1, not
> everyone reads UTF-8.

"Everyone" who speaks a Western European language, perhaps; and even 
then, mostly because a lot of tools still have a "oh, it's not valid 
UTF-8, guess iso-8859-1" mode.  The most common instance of non-ASCII 
characters in Linux kernel code are people's names, and there are plenty 
of names which aren't representable in either ASCII or iso-8859-1.

The debate on this was years ago, and the consensus was to migrate to 
UTF-8; however, the salient information should be expressed in the ASCII 
character set unless impossible.

	-hpa

