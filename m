Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYJBO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYJBO1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYJBO1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 10:27:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:43842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbYJBO1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 10:27:08 -0400
Date: Thu, 2 Oct 2008 07:26:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002072650.248373ea@infradead.org>
In-Reply-To: <20081002134736.GH19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<87fxnfpjqj.fsf@basil.nowhere.org>
	<20081002075511.GX19428@kernel.dk>
	<20081002093326.GF30001@disturbed>
	<20081002094537.GA19428@kernel.dk>
	<20081002061433.4e995075@infradead.org>
	<20081002132746.GG19428@kernel.dk>
	<20081002063606.512decb3@infradead.org>
	<20081002134736.GH19428@kernel.dk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 15:47:37 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Yes, it'll report '0' which means 'not set'. The kernel inteprets 'not
> set' as the default values, BE/4. There's a big diffence, since '0'
> means that we track CPU nice values where as if it returned be/4 then
> that is a strict/fixed setting.

argh. "0" means both "not set" and "highest priority".

how about we fix this?

right now "query + set" isn't idempotent.....
it should be able to be that.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
