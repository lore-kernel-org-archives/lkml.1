Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZD0QkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZD0QkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbZD0QkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:40:06 -0400
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:34945 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755315AbZD0QkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:40:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XSAFF9+t47wCXv6LU6qzffLOpvRcTG/ck66R1PPSbESU3gPBe/gUyWqTRFaeLLKsG9owKAPe1R+068he2C0GS3D4gI3zml6MzwKbbGayZUCoTObH07OElPeBsijfmYtb;
Date: Mon, 27 Apr 2009 09:38:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Niel Lambrechts" <niel.lambrechts@gmail.com>, eric@anholt.net
Subject: Re: [Bug #13180] 2.6.30-rc2: WARNING at i915_gem.c for
 i915_gem_idle
Message-ID: <20090427093847.778dcd81@hobbes>
In-Reply-To: <Fg2zLW93smL.A.hKC.tc48JB@chimera>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
	<Fg2zLW93smL.A.hKC.tc48JB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 21:31:51 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13180
> Subject		: 2.6.30-rc2: WARNING at i915_gem.c for
> i915_gem_idle Submitter	: Niel Lambrechts
> <niel.lambrechts@gmail.com> Date		: 2009-04-21 21:35 (5
> days old) References	:
> http://marc.info/?l=linux-kernel&m=124034980819102&w=4

Can you elaborate the issues you're seeing with UXA+KMS?  EXA had some
breakage in several configs, though it shouldn't have caused gem_idle
warnings (those are real bugs I think).

Cc'ing Eric since this is more his area.

-- 
Jesse Barnes, Intel Open Source Technology Center
