Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbYFLXMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbYFLXMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760337AbYFLXLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:11:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754702AbYFLXLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:11:07 -0400
Date: Thu, 12 Jun 2008 16:10:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial
 console
Message-Id: <20080612161049.3bb2f1a3.akpm@linux-foundation.org>
In-Reply-To: <4851AA00.1050006@sgi.com>
References: <20080612223802.528617000@polaris-admin.engr.sgi.com>
	<20080612223802.673729000@polaris-admin.engr.sgi.com>
	<20080612154600.fac8cc6b.akpm@linux-foundation.org>
	<4851AA00.1050006@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 15:58:08 -0700
Mike Travis <travis@sgi.com> wrote:

> Andrew Morton wrote:
> > On Thu, 12 Jun 2008 15:38:03 -0700
> > Mike Travis <travis@sgi.com> wrote:
> > 
> >>  * Add config option EARLY_SERIAL_CONSOLE to enable early
> >>    printk's to be directed to the serial console.
> ...
> >>
> > 
> > Confused.  What's wrong with console=uart,...?
> > 
> 
> The problem is that I need the output really, really early before
> the console is initialized.

Sorry, I meant earlycon=uart..
