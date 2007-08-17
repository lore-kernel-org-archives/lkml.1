Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXHQV7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXHQV7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbXHQV7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:59:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58861 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXHQV7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:59:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] x86_64: Save registers in saved_context during suspend and hibernation
Date: Sat, 18 Aug 2007 00:09:33 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708171526.23250.rjw@sisk.pl> <20070817140820.63c22071.akpm@linux-foundation.org>
In-Reply-To: <20070817140820.63c22071.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708180009.34482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 17 August 2007 23:08, Andrew Morton wrote:
> On Fri, 17 Aug 2007 15:26:22 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > During hibernation and suspend on x86_64 save CPU registers in the saved_context
> > structure rather than in a handful of separate variables.
> 
> You have "-mm" in the subject but afaict this patch is not dependent upon
> anything in -mm?

It shouldn't be.  The -mm means that I regard it as -mm material.
