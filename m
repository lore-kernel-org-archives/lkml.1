Return-Path: <linux-kernel-owner+w=401wt.eu-S1763434AbXHCUgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763434AbXHCUgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbXHCUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:36:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:55759 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbXHCUgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:36:36 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Len Brown <lenb@kernel.org>
Subject: Re: Asus A8N-SLI Deluxe latest BIOS wants acpi_use_timer_override
Date: Fri, 3 Aug 2007 22:36:33 +0200
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46B37619.2030205@shaw.ca> <200708032201.15355.ak@suse.de> <200708031627.56585.lenb@kernel.org>
In-Reply-To: <200708031627.56585.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708032236.33241.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Is it possible to open a bugzilla and drop the acpidump and dmesg
> from both the new and old BIOS in it?

My guess is that they changed some bits outside the DSDT. But ok
makes sense.
 
> Assuming the override in both cases is identical, I'm really baffled
> by this failure.  It seems that the new BIOS is playing some tricks
> that we have not seen before, as your hardware didn't change...

There is some flexibility in how the interrupt gets delivered, since it
gets converted to a HT message and the Northbridge has a few tweaks for
processing those.

-Andi

