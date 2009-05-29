Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZE2VwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZE2VwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZE2Vvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:51:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41497 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752442AbZE2Vvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:51:53 -0400
Date: Fri, 29 May 2009 22:52:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [0/16] HWPOISON: Intro
Message-ID: <20090529225202.0c61a4b3@lxorguk.ukuu.org.uk>
In-Reply-To: <200905291135.124267638@firstfloor.org>
References: <200905291135.124267638@firstfloor.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 23:35:25 +0200 (CEST)
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Another version of the hwpoison patchkit. I addressed 
> all feedback, except:
> I didn't move the handlers into other files for now, prefer
> to keep things together for now
> I'm keeping an own pagepoison bit because I think that's 
> cleaner than any other hacks.
> 
> Andrew, please put it into mm for .31 track.

Andrew please put it on the "Andi needs to justify his pageflags" non-path

I'm with Rik on this - we may have a few pageflags handy now but being
slack with them for an obscure feature that can be done other ways and
isn't performance critical is just lazy and bad planning for the long
term.

Andi - "I'm doing it my way so nyahh, put it into .31" doesn't fly. If
you want it in .31 convince Rik and me and others that its a good use of
a pageflag.

Alan
