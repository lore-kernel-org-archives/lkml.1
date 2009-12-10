Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbZLJBu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbZLJBu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759387AbZLJBuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:50:55 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38005
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380AbZLJBuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:50:55 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Wed, 9 Dec 2009 19:50:58 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
References: <200912080317.08254.rob@landley.net> <200912091740.43147.rob@landley.net> <4B203691.7020203@zytor.com>
In-Reply-To: <4B203691.7020203@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912091950.58950.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 December 2009 17:45:21 H. Peter Anvin wrote:
> On 12/09/2009 03:40 PM, Rob Landley wrote:
> > This is why reducing the perl version to just the precomputed constants
> > wouldn't work either.  (They're there so that you only need to install a
> > random cpan library when surprised by a build break on non-x86 machines.)
>
> It's not "a random CPAN library" - it's a core module.

Then why cache large quantities of its output and test for its existence?

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
