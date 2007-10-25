Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbXJYSfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbXJYSfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXJYSfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:35:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbXJYSfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:35:22 -0400
Date: Thu, 25 Oct 2007 14:34:59 -0400
From: Rik van Riel <riel@redhat.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux machines dieing in swap storms
Message-ID: <20071025143459.64794cc3@bree.surriel.com>
In-Reply-To: <1193325641.5776.21.camel@localhost.localdomain>
References: <1193325641.5776.21.camel@localhost.localdomain>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 16:20:41 +0100
Richard Purdie <rpurdie@rpsys.net> wrote:

> Advice on solving this welcome preferably in mainline but I'll happily
> hack my kernels with a workaround if need be.

I can't see any easy hacks or workarounds to fix the issue in the
current MM, except maybe activate the OOM killer if the amount of
page cache and buffer cache is really low and swap is full...

In the longer run, I'm working on:

http://linux-mm.org/PageReplacementDesign

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
