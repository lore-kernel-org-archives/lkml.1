Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZLIO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZLIO4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZLIO4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:56:21 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57996 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZLIO4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:56:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rFHHy2wn3SPFlLpNjRSETl70OKSq1ZOBY5jMjbKwKHesi5VRvL08yjdB2RemGb2vjt
         YRthpnIFGD0NRYbuoio7IwXdQD/s/cYQkZlP0zAp18RNGsbaBGyJ/OsDRvIbhrqT4Kzc
         jZJejj/3CqavBDIAvyc1wkZBYN0AyddKGqldI=
Date: Wed, 9 Dec 2009 17:56:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, macro@linux-mips.org,
       yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] x86,mcheck: Thermal monitoring depends on APIC
	being enabled
Message-ID: <20091209145619.GA5788@lenovo>
References: <20091208155316.561853924@openvz.org> <20091208155557.148499355@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208155557.148499355@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 06:53:17PM +0300, Cyrill Gorcunov wrote:
> Add check if APIC is not disabled since thermal
> monitoring depends on it. As only apic gets disabled
> we should not try to install "thermal monitor" vector,
> print out that thermal monitoring is enabled and etc...
> 
> Note that "Intel Correct Machine Check Interrupts" already
> has such a check as well.
> 
> Also I decided to not add cpu_has_apic check into mcheck_intel_therm_init
> since even if it'll call apic_read on disabled apic -- it's safe
> here and allow us to save a few code bytes.
> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>

Though the second patch is not for merging (i'm working on it) --
this one is still valid.
 
	-- Cyrill
