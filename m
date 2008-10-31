Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYJaHfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYJaHfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYJaHfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:35:17 -0400
Received: from lazybastard.de ([212.112.238.170]:54672 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYJaHfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:35:16 -0400
Date: Fri, 31 Oct 2008 08:35:07 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031073507.GB18182@logfs.org>
References: <20081026124643.GA1328@logfs.org> <20081030174300.GA1773@ucw.cz> <20081030175844.GC7157@logfs.org> <200810310738.46326.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810310738.46326.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 07:38:46 +0100, Christian Borntraeger wrote:
> Am Donnerstag, 30. Oktober 2008 schrieb Jörn Engel:
> > Except that min/max in include/linux/kernel.h have some type-safety
> > added.  In this particular case that is actually a disadvantage:
> 
> So what about min_t and max_t from include/linux/kernel.h? Can that be used?

Sorry, no.  The problems comes from using MAX in structure initializers.

struct btree_geo btree_geo32 = {
	.keylen = 1,
	.no_pairs = NODESIZE / sizeof(long) / 2,
};

Jörn

-- 
Correctness comes second.
Features come third.
Performance comes last.
Maintainability is easily forgotten.
