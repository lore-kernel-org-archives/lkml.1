Return-Path: <linux-kernel-owner+w=401wt.eu-S934541AbYEBMH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541AbYEBMH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761551AbYEBMHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:07:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54666 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759985AbYEBMHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:07:50 -0400
Date: Thu, 1 May 2008 07:07:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds
Message-ID: <20080501070725.6522bd7d@infradead.org>
In-Reply-To: <loom.20080502T110150-114@post.gmane.org>
References: <4819E316.7000607@krogh.cc>
	<20080501223938.921f7cd2.akpm@linux-foundation.org>
	<481ACEC4.2040205@krogh.cc>
	<20080501051548.08bbbec1@infradead.org>
	<loom.20080502T110150-114@post.gmane.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 11:03:16 +0000 (UTC)
Jesper Krogh <jesper@krogh.cc> wrote:

> Arjan van de Ven <arjan <at> infradead.org> writes:
> > On Fri, 02 May 2008 10:20:20 +0200
> > Jesper Krogh <jesper <at> krogh.cc> wrote:
> > > This is the only activity on the system .. so a load of 1 /
> > > 16cpus.
> > 
> > have you run fsck on the filesystem?
> 
> Yes.. the first thing i did was a forced fsck .. and it was clean. 
> 
> > (and it might be interesting to use dump the metadata to a file
> > first to save the broken state for later analysis)
> 
> All 4.5TB? 

metdata only; the "e2image" program only saves metadata, not data... so
it'll be a lot less than 4.5tb..

> 
