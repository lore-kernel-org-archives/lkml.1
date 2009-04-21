Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbZDUTSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbZDUTSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZDUTSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:18:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51077 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbZDUTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:18:20 -0400
Date: Tue, 21 Apr 2009 20:18:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
Message-ID: <20090421191817.GA9419@srcf.ucam.org>
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090421183100.GA8120@srcf.ucam.org> <49EE1945.2080808@dell.com> <20090421191242.GA8445@srcf.ucam.org> <49EE1B9F.2030504@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE1B9F.2030504@dell.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 02:16:47PM -0500, Mario Limonciello wrote:
> Hi Matthew:
> 
> Matthew Garrett wrote:
> > Hm. But if we get the scancode, presumably we can do this anyway?
> >   
> Yes, this information might not be as useful on Linux as it is for the
> Windows situation.  On Windows, the WMI event doesn't translate directly
> into a key, but rather a userspace application makes the changes.  As it
> stands right now, the keys still don't do anything with my patch(s). 
> They're at least documented however in case someone would like to change
> this behavior at some point.

Ok. As long as there's a way of determining when a platform no longer 
sends scancodes (and so we can switch to WMI delivery), then that seems 
fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
