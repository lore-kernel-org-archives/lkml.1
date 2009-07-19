Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZGSW0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZGSW0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 18:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZGSW0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 18:26:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40763 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZGSW0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 18:26:06 -0400
Date: Sun, 19 Jul 2009 23:26:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Commit 9b57896e removed my Vaio S1 S2 keys for brightness +/-.
Message-ID: <20090719222605.GA14554@srcf.ucam.org>
References: <20090719222236.GJ6876@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090719222236.GJ6876@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 05:22:36PM -0500, Robin Holt wrote:
> Matthew,
> 
> I am not sure whether this is a bug or just something not configured
> correctly.  I am running Ubuntu 9.04 and finally decided to find out why
> the S1 and S2 buttons no longer brighten or dim the display.  Prior to
> commit 9b57896e, they behaved equivalent to the Fn-F5 and Fn-F6 keys
> for brightness up/down.

I suspect that they're now working correctly, whereas previously they 
weren't. Do they generate input events when you press them? You can 
probably map them back to KEY_BRIGHTNESSUP and KEY_BRIGHTNESSODNW.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
