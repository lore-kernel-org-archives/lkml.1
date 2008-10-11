Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYJKRFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYJKRFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 13:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbYJKRFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 13:05:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58755 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759296AbYJKRFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 13:05:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
Date: Sat, 11 Oct 2008 19:09:48 +0200
User-Agent: KMail/1.9.9
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       linux acpi <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <48F0DB0C.7060201@tuffmail.co.uk>
In-Reply-To: <48F0DB0C.7060201@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810111909.48897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 11 of October 2008, Alan Jenkins wrote:
> I've just run an acpi-test kernel on my EeePC and noticed a new issue. 
> It seems to be caused (or revealed) by the EC interrupt transaction patch.
> 
> On the second suspend/resume cycle, I see a kernel error message.
> 
> [   78.747707] ACPI: Waking up from system sleep state S3
> [   79.330001] ACPI: EC: input buffer not empty, aborting transaction
> [   79.423327] ACPI: EC: non-query interrupt received, switching to
> interrupt mode
> 
> I still don't see any issues in the code.  I'll try getting a DEBUG
> trace to see the EC interrupts.  Any other suggestions?

Not really, but is this reproducible?  I mean, does it happen always on the
second resume and does it happen on every next resume after the first one?

Thanks,
Rafael
