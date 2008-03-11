Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYCKR3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYCKR3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYCKR3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:29:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:39439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYCKR3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:29:22 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: mpparse_{32,64}.c merge questions
Date: Tue, 11 Mar 2008 13:28:43 -0400
User-Agent: KMail/1.9.9
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <47CDB9D7.9030107@suse.de> <47CDBFD9.1050703@suse.de> <20080304213552.GD8944@elte.hu>
In-Reply-To: <20080304213552.GD8944@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111328.43314.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Ingo Molnar wrote:
> 
> (more folks Cc:-ed)
> 
> * Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
> 
> >>> I've decided to start with merge of mpparse files, and I'd like to 
> >>> know your opinion on some differences... Ingo, I know you work on 
> >>> merging the 32/64 files, do I step on your toes?
> >>
> >> My suggestion would be to do a redesign first and then do that for 
> >> both.
> > I was thinking that redesign on one file would go easier... And we 
> > don't need both, do we?
> 
> we dont, but please do _not_ "redesign" anything during unification.
> 
> try to keep it simple and bisectable. Lots of small patches. Stupid
> #ifdefs if need to be. Pick the 32-bit version or the 64-bit version of
> any approach, if it's obvious that the unified version will still work 
> fine. Ask if in doubt.


I agree with Ingo on the "keep it simple" merge steps..

I can't resist mentioning, however, what I'd like to see long term.

I'd like to see mpparse.o depend on CONFIG_MPS=y
I'd like to be able to build CONFIG_ACPI=y and CONFIG_MPS=n

Andy Grover prototyped splititing MPS from ACPI a while back,
but it never made it upstream.

thanks,
-Len
