Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbXGKJmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbXGKJmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbXGKJlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:41:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56978 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075AbXGKJlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:41:52 -0400
Date: Wed, 11 Jul 2007 10:41:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>, dedekind@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] try_module_get usage
Message-ID: <20070711094149.GD19061@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
	Rusty Russell <rusty@rustcorp.com.au>, dedekind@infradead.org,
	linux-kernel@vger.kernel.org
References: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 04:55:31PM +0900, Fernando Luis V?zquez Cao wrote:
> I keep seeing uses of try_module_get(THIS_MODULE) which seem to mimic
> the behavior of the former MOD_INC_USE_COUNT. The UBI driver is one
> example:

It's of course buggy as hell.  But UBI folks prefer not to listen to
advice and keep their bugs.

