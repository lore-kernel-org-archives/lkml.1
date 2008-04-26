Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYDZPT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYDZPT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYDZPTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:19:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbYDZPTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:19:18 -0400
Date: Sat, 26 Apr 2008 08:18:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] capabilities: implement per-process securebits
Message-Id: <20080426081810.7f1245e7.akpm@linux-foundation.org>
In-Reply-To: <47BA3E21.2020303@kernel.org>
References: <47BA3E21.2020303@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 18:25:37 -0800 "Andrew G. Morgan" <morgan@kernel.org> wrote:

> Here is the patch to add per-process securebits again. This version
> includes Serge's argument type fix (thanks), but is otherwise unchanged
> from the one posted a couple of weeks back. It is against Linus' tree as
> of a the 15th.

The hitherto-invisible-to-me PR_GET_TSC and PR_SET_TSC have turned up in
mainline, so I have renumbered your prctl options to

/* Get/set securebits (as per security/commoncap.c) */
#define PR_GET_SECUREBITS 27
#define PR_SET_SECUREBITS 28

