Return-Path: <linux-kernel-owner+w=401wt.eu-S1762407AbXHNXV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762407AbXHNXV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbXHNXVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:21:11 -0400
Received: from adsl-67-117-79-109.dsl.sntc01.pacbell.net ([67.117.79.109]:2633
	"EHLO aurum.uhlenkott.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbXHNXVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:21:10 -0400
Date: Tue, 14 Aug 2007 16:21:07 -0700
From: Jason Uhlenkott <jasonuhl@jasonuhl.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
Message-ID: <20070814232107.GA4265@aurum.uhlenkott.net>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1187132149.2618.2.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 15:55:48 -0700, Arjan van de Ven wrote:
> NULL is not 0 though.

It is.  Its representation isn't guaranteed to be all-bits-zero, but
the constant value 0 when used in pointer context is always a null
pointer (and in fact the standard requires that NULL be #defined as 0
or a cast thereof).
