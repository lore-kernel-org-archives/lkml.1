Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYJOI6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYJOI6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYJOI6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:58:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46810 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYJOI6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:58:21 -0400
Date: Wed, 15 Oct 2008 09:58:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Brown <john.brown3@hp.com>
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
Message-ID: <20081015085809.GA1061@srcf.ucam.org>
References: <200810142254.07024.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810142254.07024.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 10:54:06PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
> 
> HP xw4600 Workstation is known to require the "old" (ie. compatible
> with ACPI 1.0) suspend code ordering, so blacklist it for this
> purpose.

This doesn't seem to be scaling especially well. The xw4600 is a new 
machine, so if it needs the "old" code ordering then that's a strong 
indication that we're doing something wrong. I think trying to work out 
what would be more useful than just adding it to a blacklist.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
