Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZBTQhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZBTQhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZBTQg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:36:56 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49580 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbZBTQgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:36:55 -0500
Date: Fri, 20 Feb 2009 16:36:51 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       lenb@kernel.org
Subject: Re: [PATCH] oqo: depends on INPUT_POLLDEV
Message-ID: <20090220163651.GA698@srcf.ucam.org>
References: <20090220083007.7bd0a153.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220083007.7bd0a153.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 08:30:07AM -0800, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> oqo driver uses polled input functions, so make it depend
> on INPUT_POLLDEV.
> 
> ERROR: "input_register_polled_device" [drivers/platform/x86/oqo-wmi.ko] undefined!
> ERROR: "input_allocate_polled_device" [drivers/platform/x86/oqo-wmi.ko] undefined!
> ERROR: "input_free_polled_device" [drivers/platform/x86/oqo-wmi.ko] undefined!
> ERROR: "input_unregister_polled_device" [drivers/platform/x86/oqo-wmi.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc:	Matthew Garrett <mjg59@srcf.ucam.org>

Acked-by: Matthew Garrett <mjg@redhat.com>

I've got a cleaned up version of this written now - I'll push it to Len 
later today.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
