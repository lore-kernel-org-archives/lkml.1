Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYAIAhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYAIAhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYAIAhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:37:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbYAIAhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:37:03 -0500
Date: Tue, 8 Jan 2008 16:31:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: jbeulich@novell.com, hch@infradead.org, pagg@oss.sgi.com, erikj@sgi.com,
       matthltc@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] add task handling notifier
Message-Id: <20080108163120.e1b42c30.akpm@linux-foundation.org>
In-Reply-To: <20080108180309.4ccab28d.pj@sgi.com>
References: <476A780C.76E4.0078.0@novell.com>
	<20071223122621.GA19310@infradead.org>
	<20071225140526.547a882f.akpm@linux-foundation.org>
	<47838ACB.76E4.0078.0@novell.com>
	<20080108141424.de5d8fba.akpm@linux-foundation.org>
	<20080108180309.4ccab28d.pj@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 18:03:09 -0600
Paul Jackson <pj@sgi.com> wrote:

> Andrew wrote:
> > What are those (unidentified) add-on features doing at present?
> > Patching calls into fork.c/exec.c/exit.c?
> 
> Most likely.  I suspect we have general agreement and awareness
> that such patching is not something that sells well in Linux-land.
> And for good reason in my personal view ... such patching by loadable
> modules could open the door to compromising the integrity of Linux in
> ways that could be dangerous.
> 

err, no.

What I meant was that the providers of these mystery features are
presumably also patching into fork.c/exec.c/exit.c at the source code level
so as to enable the mystery features within their overall kernel package.

If so, this doesn't sounds terribly onerous.
