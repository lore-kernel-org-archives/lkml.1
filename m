Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYCFRaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYCFRaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYCFR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:29:47 -0500
Received: from hu-out-0506.google.com ([72.14.214.226]:23082 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYCFR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:29:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J6qrNRrTKCLul6V1AR5xY3Gebm3QeiS+N4RSLPr2mptJ9ZhuLMP+mxUbQebStLbJ6ZiGbrDqlzmvz5uhB7vo9UidB2X3VHQUd8WopNY00uDai5gDgpEIF3P+a2uAtRESxGh+EdAhXQKzdd6OEQ1qQV90j2cEi1W9UcG42U0zhb8=
Message-ID: <f24d23310803060929k30f17947mda54a6de2bc294a3@mail.gmail.com>
Date: Thu, 6 Mar 2008 22:59:44 +0530
From: "debian developer" <debiandev@gmail.com>
To: "Stephen Cuppett" <cuppett@gmail.com>
Subject: Re: Performance versus FreeBSD 7.0
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 7:08 PM, Stephen Cuppett <cuppett@gmail.com> wrote:
> Not lobbing the first artillery shell by any means, but I saw this
>  bullet on the FreeBSD release announcement:
>
>  # Dramatic improvements in performance and SMP scalability shown by
>  various database and other benchmarks, in some cases showing peak
>  performance improvements as high as 350% over FreeBSD 6.X under normal
>  loads and 1500% at high loads. When compared with the best performing
>  Linux kernel (2.6.22 or 2.6.24) performance is 15% better. Results are
>  from benchmarks used to analyze and improve system performance,
>  results with your specific work load may vary. Some of the changes
>  that contribute to this improvement are:
>
>     * The 1:1 libthr threading model is now the default.
>     * Finer-grained IPC, networking, and scheduler locking.
>     * A major focus on optimizing the SMP architecture that was put in
>  place during the 5.x and 6.x branches.
>
>  Some benchmarks show linear scaling up to 8 CPUs. Many workloads see a
>  significant performance improvement with multicore systems.
>
>  The whole thing is available at:
>
>  http://www.freebsd.org/releases/7.0R/announce.html
>
>  However, their site is pretty scant on details about those benchmarks.
>   Was just curious if anybody on this list had any input or links on
>  the metrics, the hardware, the workloads, how was Linux or FreeBSD
>  tuned, knew more information, could point me to the stats....

The benchmarks are posted here

http://people.freebsd.org/~kris/scaling/7.0%20Preview.pdf

page no 17-20.

A funny quote on CFS from above (page 19)

"The new CFS scheduler in 2.6.23 is "Completely Fair"...to
FreeBSD" :)

good to see some competition at last :D
