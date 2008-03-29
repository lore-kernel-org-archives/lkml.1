Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYC2R0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYC2R0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYC2RZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:25:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46731 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbYC2RZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:25:56 -0400
Date: Sat, 29 Mar 2008 17:25:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacek Luczak <difrost.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
Message-ID: <20080329172551.GA9785@ZenIV.linux.org.uk>
References: <47EE75A0.8070705@gmail.com> <47EE7A66.30905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EE7A66.30905@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 10:20:38AM -0700, H. Peter Anvin wrote:
> Jacek Luczak wrote:
> >Hi All,
> >
> >I've found that in many enum lists, there's a comma at the end, e.g. 
> >(arch/x86/kernel/early_printk.c):
> >
> >enum {
> >        MAGIC1 = 0xBACCD00A,
> >        MAGIC2 = 0xCA110000,
> >        XOPEN = 5,
> >        XWRITE = 4,
> >};
> >
> >Just out of curiosity, is there any particular reason here (no word in 
> >CodingStyle about that).
> >
> 
> Yes, it's so you can add a line without affecting the line before it, 
> making a one-line patch into a two-line patch that's more likely to 
> conflict.

Note that doing that makes sense only when you can expect additions to
the end and even then it's a matter of taste.
