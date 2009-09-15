Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZIOT1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZIOT1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbZIOT1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:27:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54437 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZIOT1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:27:30 -0400
Date: Tue, 15 Sep 2009 20:27:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] backlight: Provide two stage registration
Message-ID: <20090915192730.GA8152@srcf.ucam.org>
References: <1253031583-11286-1-git-send-email-mjg@redhat.com> <1253042322.30165.52.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253042322.30165.52.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 08:18:42PM +0100, Richard Purdie wrote:

> Could we not pass an optional pointer to a properties structure to
> create the backlight with instead or find a better way to solve this?

That'd work, but it'd involve significant refactoring of all the 
drivers - we really need to be setting max_brightness before 
device_register() is called. I suspect it'd be an even larger delta 
against mainline.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
