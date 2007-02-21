Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXBUJYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXBUJYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 04:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXBUJYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 04:24:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32860 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965352AbXBUJYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 04:24:52 -0500
Subject: Re: [PATCH 1/3] slab: introduce krealloc
From: Arjan van de Ven <arjan@infradead.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
In-Reply-To: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 21 Feb 2007 10:24:35 +0100
Message-Id: <1172049875.3531.169.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 10:06 +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Introduce krealloc() for reallocating memory while preserving contents.


please mark this one __must_check.. not storing realloc() return values
is one of the more nasty types of bugs... but gcc can help us greatly
here ;)


