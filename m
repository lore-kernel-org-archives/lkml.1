Return-Path: <linux-kernel-owner+w=401wt.eu-S1762591AbXGKKCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591AbXGKKCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbXGKKCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:02:22 -0400
Received: from smtp.nokia.com ([131.228.20.172]:25948 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889AbXGKKCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:02:22 -0400
Subject: Re: [PATCH RFC] try_module_get usage
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <20070711094149.GD19061@infradead.org>
References: <1184140531.4608.16.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070711094149.GD19061@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 11 Jul 2007 13:01:52 +0300
Message-Id: <1184148112.3531.97.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Jul 2007 10:01:52.0791 (UTC) FILETIME=[817CDA70:01C7C3A2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 10:41 +0100, Christoph Hellwig wrote:
> On Wed, Jul 11, 2007 at 04:55:31PM +0900, Fernando Luis V?zquez Cao
> wrote:
> > I keep seeing uses of try_module_get(THIS_MODULE) which seem to
> mimic
> > the behavior of the former MOD_INC_USE_COUNT. The UBI driver is one
> > example:
> 
> It's of course buggy as hell.  But UBI folks prefer not to listen to
> advice and keep their bugs.

Christoph, stop this please, point the bugs we do not listen about. Your
patches sit in the UBI git and wait for the merge window:

http://git.infradead.org/?p=ubi-2.6.git;a=summary

I plan to let dwmw2 pull them and send to Linus together with other
MTD/JFFS2 patches. If you have specific requests - go ahead.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

