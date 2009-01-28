Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZA1AQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZA1AQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZA1AQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:16:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbZA1AQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:16:22 -0500
Date: Tue, 27 Jan 2009 16:15:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: prasad@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, roland@redhat.com,
       mingo@elte.hu, richardj_moore@uk.ibm.com, naren@linux.vnet.ibm.com
Subject: Re: [RFC Patch 0/9] Hardware Breakpoint interfaces - v4
Message-Id: <20090127161518.88ac3f1c.akpm@linux-foundation.org>
In-Reply-To: <20090122135640.GA11161@in.ibm.com>
References: <20090122135640.GA11161@in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 19:26:40 +0530
"K.Prasad" <prasad@linux.vnet.ibm.com> wrote:

> Hi All,
> 	Please find the new set of patches that introduce kernel
> interfaces to use Hardware Breakpoint registers and an implementation
> for x86 (and x86_64) architecture, now labelled as Version IV.

What a lot of code.  It looks very readable, although I haven't read it
yet.

What I'm missing is a general overview: what does the feature do?  Why
do we need it in the kernel?  What is the value?

I see mention of converting kgdb.  OK.  But are there plans to convert
anything else in-kernel to use this?

I see some exported-to-modules API for kernel developers to use (I
assume).  It would be appropriate to add an overview of that capability
in the [0/n] patch description.

Similarly I see something about "user breakpoints" but I'm not seeing
any description of what they are, nor how they are used, nor what value
they bring, etc.


IOW, we need the glossy sales brochure, please.
