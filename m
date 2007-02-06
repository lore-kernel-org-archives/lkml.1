Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXBFMaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXBFMaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXBFMaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:30:25 -0500
Received: from colin.muc.de ([193.149.48.1]:3053 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXBFMaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:30:24 -0500
Date: 6 Feb 2007 13:30:23 +0100
Date: Tue, 6 Feb 2007 13:30:23 +0100
From: Andi Kleen <ak@muc.de>
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 5/11] Fix PIT override bug for paravirt
Message-ID: <20070206123023.GE47229@muc.de>
References: <200702060353.l163r2hU000745@zach-dev.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702060353.l163r2hU000745@zach-dev.vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 07:53:02PM -0800, Zachary Amsden wrote:
> The time initialization changed for i386 when some code moved into time_init.
> This made it no longer possible to override the PIT / HPET, which broke
> paravirt guests.

Looks still fragile. Can this be done cleaner? 

In particularly some comments would be good, but clearer code 
logic would be preferred.

-Andi
