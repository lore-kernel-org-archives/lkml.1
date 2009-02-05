Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbZBEL1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbZBEL1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 06:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZBEL07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 06:26:59 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37475 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZBEL07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 06:26:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rz22gsj2GhykFe4dhY6g5wmjGVfJx+pimd2L6rh4wc2Cj857r6DFGlD2HVco+mqI9z
         CHS7vgw4Sgit4OZL4OpiKklMHQ/syzzIlij0BTBYXXupd+uKtxtgHfLW//MbVO/rtnJH
         eYhRjvagPKs7I/uWkvXr00C33bLDz9ABuMESQ=
MIME-Version: 1.0
In-Reply-To: <20090201130058.GA486@elte.hu>
References: <8c5a844a0901220851g1c21169al4452825564487b9a@mail.gmail.com>
	 <Pine.LNX.4.64.0901221658550.14302@blonde.anvils>
	 <8c5a844a0901221500m7af8ff45v169b6523ad9d7ad3@mail.gmail.com>
	 <20090122231358.GA27033@elte.hu>
	 <8c5a844a0901230310h7aa1ec83h60817de2b36212d8@mail.gmail.com>
	 <8c5a844a0901281331w4cea7ab2y305d5a1af96e313e@mail.gmail.com>
	 <20090129141929.GP24391@elte.hu>
	 <8c5a844a0902010319t20b853d0t6c156ecc84543f30@mail.gmail.com>
	 <20090201130058.GA486@elte.hu>
Date: Thu, 5 Feb 2009 13:26:58 +0200
Message-ID: <8c5a844a0902050326v2155dbeaq5449f1e373f4245d@mail.gmail.com>
Subject: Re: [PATCH 2.6.28 1/2] memory: improve find_vma
From: Daniel Lowengrub <lowdanie@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 1, 2009 at 3:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  you should time it:
>
>  time ./mmap-perf
>
> and compare the before/after results.
>
>        Ingo
>

I made a script that runs 'time ./mmap-perf' 100 times and outputs the
average.  The output on the standard kernel was:
real: 1.022600
user: 0.135900
system: 0.852600
The output after the patch was:
real: 0.815400
user: 0.113200
system: 0.622200
These results were consistent which isn't surprising considering the
fact that they themselves are averages.
What do you think?
Daniel
