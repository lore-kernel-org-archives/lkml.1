Return-Path: <linux-kernel-owner+w=401wt.eu-S1765868AbXHDTUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765868AbXHDTUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765107AbXHDTUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:20:01 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54014
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbXHDTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:20:00 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/2] Group architecture Documentation under Documentation/arch.
Date: Sat, 4 Aug 2007 15:19:54 -0400
User-Agent: KMail/1.9.6
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>
References: <200705222225.39949.rob@landley.net> <Pine.LNX.4.64.0705230922580.19474@anakin> <200708041404.01264.rob@landley.net>
In-Reply-To: <200708041404.01264.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041419.55454.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007 2:03:59 pm Rob Landley wrote:
> Signed-off-by: Rob Landley <rob@landley.net>
> Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Move architecture-specific Documentation into a common subdirectory.

I really, really, really hate git.

Ok, on my laptop I just noticed that "git apply" of the patch didn't complain 
but it also left the empty subdirectories it moved stuff out of.  (I don't 
believe this happened on the version of git I was using on my previous 
laptop, which ate itself a month and change ago, but obviously I can't 
check.)

There is no "git rmdir".  "git rm" refuses to delete the directory 
without -r.  "git rm -r Documentation/x86_64" listed (as just deleted) all 
the files that the patch already moved out of the directory.

Am I missing something obvious here?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
