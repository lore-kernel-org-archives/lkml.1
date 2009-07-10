Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZGJRh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZGJRh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZGJRhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 13:37:16 -0400
Received: from kroah.org ([198.145.64.141]:35538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZGJRhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 13:37:15 -0400
Date: Fri, 10 Jul 2009 10:36:23 -0700
From: Greg KH <greg@kroah.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ming Lei <tom.leiming@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible memory leak in request_firmware()
Message-ID: <20090710173623.GA3687@kroah.com>
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 04:17:00PM +0100, Catalin Marinas wrote:
> Hi,
> 
> I get a couple kmemleak reports like below which I think happen on the
> failure path (-ENOENT) of a request_firmware() call:

<snip>

Hm, can you send me the final version of this patch, it seemed to go
through a few different versions, with a signed-off-by line?

thanks,

greg k-h
