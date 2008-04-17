Return-Path: <linux-kernel-owner+w=401wt.eu-S1762705AbYDQOIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762705AbYDQOIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYDQOHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:07:51 -0400
Received: from lazybastard.de ([212.112.238.170]:52693 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbYDQOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:07:50 -0400
Date: Thu, 17 Apr 2008 16:07:35 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alex Dubov <oakad@yahoo.com>, Ben Dooks <ben@fluff.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Smartmedia/xd card support - request for comments
Message-ID: <20080417140734.GA30001@logfs.org>
References: <257448.48285.qm@web36701.mail.mud.yahoo.com> <alpine.LFD.1.10.0804171535581.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0804171535581.3261@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 April 2008 15:38:17 +0200, Thomas Gleixner wrote:
> 
> No it is not. SmardMedia is a bare NAND chip, which is already covered
> by MTD. There are already other FTLs on top of MTD and the SmartMedia
> format just can be added to those.

Isn't drivers/mtd/ssfdc.c - despite its name - an implementation of the
SmartMedia FTL?  When I last looked at it, I failed to see any
functional differences.

Jörn

-- 
Doubt is not a pleasant condition, but certainty is an absurd one.
-- Voltaire
