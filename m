Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYHIAiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYHIAiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYHIAiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:38:11 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46259 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYHIAiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:38:10 -0400
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, containers@lists.linux-foundation.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <489CD0F9.9060603@cs.columbia.edu>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu>
	 <200808090029.28286.arnd@arndb.de>  <489CD0F9.9060603@cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 17:38:06 -0700
Message-Id: <1218242286.19082.62.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 19:04 -0400, Oren Laadan wrote:
> > struct pt_regs is part of the kernel ABI, it will not change.
> 
> I'm in favor about keeping the format identical between the variations of
> each architecture. Note, however, that "struct pt_regs" won't do because it
> may change with these variations.

"Part of the kernel ABI" makes it sound to me like it won't change.
Who's right here? :)

-- Dave

