Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZEKUGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZEKUGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZEKUF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:05:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:53163 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbZEKUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ssl/5La8LlO7BHLKm8dVxcJxnf6p39zC4H2D3Cn9AXQWwokdOerqWJBmtq/sSXsld3
         SC1YmmZGhOa0LYe6jf2y++b+F5XSNxCqpu3Zl1wzW9mlEU6ag15vzxZ2dKGPcZYK1gVB
         IdPfKXqL4EBeD3lu8h2DIB/cVz/h4nuCIDuRI=
Date: Tue, 12 May 2009 00:05:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090511200556.GQ4624@lenovo>
References: <49FC85A9.2070702@kernel.org> <tip-4401da6111ac58f94234417427d06a72c4048c74@git.kernel.org> <20090511110234.GH4648@elte.hu> <20090511134140.GH4624@lenovo> <20090511134950.GA949@elte.hu> <4A0863C5.9070206@kernel.org> <20090511180521.GL4624@lenovo> <20090511200143.GJ28684@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511200143.GJ28684@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, May 11, 2009 at 10:01:43PM +0200]
...
| 
| > Thanks Yinghai, looks really attractive!
| > 
| > But would need a good testing (seems we
| > rely on read_apic heavily in smp environment
| > even if it was disabled or not supported).
| > 
| > (btw comment about disable_apic now should
| >  contain apic->read as well or should be dropped
| >  completely since all is selfevidence from code
| >  though this is not that important i believe)
| 
| Needs a delta patch against -tip - i got this stuff stable today but 
| i dont want to replace patches as it has a problematic track record 
| already.
| 
| 	Ingo
| 

Yinghai, could you make one? (i'm off for today, seems will
be able tomorrow evening only)

	-- Cyrill
