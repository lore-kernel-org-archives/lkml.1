Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbZFBFac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbZFBFac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZFBFaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:30:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbZFBFaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:30:23 -0400
Date: Mon, 1 Jun 2009 22:29:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] fix detection of CONFIG_FRAME_WARN=0
Message-Id: <20090601222954.8e2c97c6.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0906011554l54216e73v6fe9eb54a0eadb80@mail.gmail.com>
References: <1243121915-10775-1-git-send-email-vapier@gentoo.org>
	<8bd0f97a0906011554l54216e73v6fe9eb54a0eadb80@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 18:54:27 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Sat, May 23, 2009 at 19:38, Mike Frysinger wrote:
> > The checking of CONFIG_FRAME_WARN in the top level Makefile forgot to
> > actually derefence the variable thus leading to an always true check.
> 
> Andrew: could you pick this up ?

yup, I'll shoot for 2.6.30 on this one, thanks.
