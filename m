Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXE3I57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXE3I57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXE3I5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:57:52 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:52774 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXE3I5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:57:51 -0400
Date: Wed, 30 May 2007 01:52:31 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/22] 2.6.22-rc3 perfmon2 : sampling format support
Message-ID: <20070530085231.GA20850@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmJNe019671@frankl.hpl.hp.com> <p73myzmekvv.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73myzmekvv.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, May 30, 2007 at 11:11:32AM +0200, Andi Kleen wrote:
> Stephane Eranian <eranian@frankl.hpl.hp.com> writes:
> > 
> > Each format is identified via a 128-bit UUID which can be requested
> > when the context is created with pfm_create_context().
> 
> Why does it need a uuid? Isn't a name enough?
> 
Sorry about that, the description is old and does not correspond to 
the actual code. The UUID has been removed during the previous code review.
It has been replaced by a simple string.

> There is no documentation how the locking in this file works.
> 
Which particular file?

-- 

-Stephane
