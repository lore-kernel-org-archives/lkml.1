Return-Path: <linux-kernel-owner+w=401wt.eu-S1030567AbXBUJgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030567AbXBUJgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 04:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXBUJgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 04:36:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57727 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030567AbXBUJgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 04:36:08 -0500
Subject: Re: [PATCH 1/3] slab: introduce krealloc
From: Arjan van de Ven <arjan@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
In-Reply-To: <84144f020702210133k4a9f40f0mc0f51524fac9c524@mail.gmail.com>
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
	 <1172049875.3531.169.camel@laptopd505.fenrus.org>
	 <84144f020702210133k4a9f40f0mc0f51524fac9c524@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 21 Feb 2007 10:36:02 +0100
Message-Id: <1172050562.3531.171.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 11:33 +0200, Pekka Enberg wrote:
> On 2/21/07, Arjan van de Ven <arjan@infradead.org> wrote:
> > please mark this one __must_check.. not storing realloc() return values
> > is one of the more nasty types of bugs... but gcc can help us greatly
> > here ;)
> 
> So I guess we want the same thing for the other allocator functions
> (__kmalloc et al) as well?

kmalloc doesn't normally get forgotten. realloc() otoh is a very classic
and far more frequent mistake....

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

