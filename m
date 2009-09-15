Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbZIOTqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbZIOTqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZIOTp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:45:56 -0400
Received: from dan.rpsys.net ([93.97.175.187]:63457 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZIOTp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:45:56 -0400
Subject: Re: [PATCH 1/3] backlight: Provide two stage registration
From: Richard Purdie <rpurdie@rpsys.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090915192730.GA8152@srcf.ucam.org>
References: <1253031583-11286-1-git-send-email-mjg@redhat.com>
	 <1253042322.30165.52.camel@dax.rpnet.com>
	 <20090915192730.GA8152@srcf.ucam.org>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 20:42:15 +0100
Message-Id: <1253043735.30165.59.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 20:27 +0100, Matthew Garrett wrote:
> On Tue, Sep 15, 2009 at 08:18:42PM +0100, Richard Purdie wrote:
> 
> > Could we not pass an optional pointer to a properties structure to
> > create the backlight with instead or find a better way to solve this?
> 
> That'd work, but it'd involve significant refactoring of all the 
> drivers - we really need to be setting max_brightness before 
> device_register() is called. I suspect it'd be an even larger delta 
> against mainline.

But the delta would result in more readable code rather than all that
error checking/handling. Can we see how ugly that diff turns out to be?

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

