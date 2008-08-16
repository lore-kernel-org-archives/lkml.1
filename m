Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYHPCxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYHPCxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 22:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYHPCw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 22:52:56 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:14101 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751967AbYHPCwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 22:52:55 -0400
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: sysprof in 2.6.27 kernel
References: <20080813083953.GF19333@ics.muni.cz>
	<ye8myjg7b4r.fsf@camel10.daimi.au.dk>
	<20080814115620.GD4674@ics.muni.cz>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 16 Aug 2008 04:52:54 +0200
In-Reply-To: <20080814115620.GD4674@ics.muni.cz>
Message-ID: <ye8zlnd6589.fsf@camel28.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek <xhejtman@ics.muni.cz> writes:

> On Thu, Aug 14, 2008 at 01:23:16AM +0200, Soeren Sandmann wrote:
> > It's somewhat rough still. If you try it out, I will be interested in
> > any feedback you have.
> 
> and another one. sysproc gui reads user addresses from the sysprof pipe with
> null pointers. is this ok or is this a bug in sysprof kernel module?

That is not ok, but it could happen if the process in question was not
compiled with framepointers. Or it could be a bug in the kernel code.


Soren
