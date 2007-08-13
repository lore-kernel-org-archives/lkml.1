Return-Path: <linux-kernel-owner+w=401wt.eu-S945769AbXHMNq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945769AbXHMNq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934609AbXHMKPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:15:18 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:41734
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934588AbXHMKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:15:15 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Distributed storage.
Date: Mon, 13 Aug 2007 03:15:08 -0700
User-Agent: KMail/1.9.5
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708130255.35828.phillips@phunq.net> <20070813100636.GL23758@kernel.dk>
In-Reply-To: <20070813100636.GL23758@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130315.08382.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007 03:06, Jens Axboe wrote:
> On Mon, Aug 13 2007, Daniel Phillips wrote:
> > Of course not.  Nothing I said stops endio from being called in the
> > usual way as well.  For this to work, endio just needs to know that
> > one call means "end" and the other means "destroy", this is
> > trivial.
>
> Sorry Daniel, but your suggestions would do nothing more than uglify
> the code and design.

Pretty much exactly what was said about shrinking struct page, ask Bill.  
The difference was, shrinking struct page actually mattered whereas 
shrinking struct bio does not, and neither does expanding it by a few 
bytes.

Regards,

Daniel
