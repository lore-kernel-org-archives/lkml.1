Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbYCCIid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbYCCIid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYCCIi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:38:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:59562 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYCCIiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:38:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mLGWYDACrt/p6WBE9X9KooFMgULyZKk30Xs4nLUJLz1Ibb0QVMUjJdB0uVPu1Mtbd
	yn2wQRaCJUimT14sc8Ckw==
Message-ID: <6599ad830803030038p2d81883bu895260a96fedaec6@mail.gmail.com>
Date: Mon, 3 Mar 2008 00:38:16 -0800
From: "Paul Menage" <menage@google.com>
To: serge@hallyn.com
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Cc: "Andrew Morton" <akpm@linux-foundation.org>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, xemul@openvz.org, pj@sgi.com
In-Reply-To: <6599ad830802281406s512ee32bkeb2b0387a7737a87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	 <20080228132142.4d4b1eef.akpm@linux-foundation.org>
	 <6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
	 <20080228213319.GC1232@vino.hallyn.com>
	 <6599ad830802281406s512ee32bkeb2b0387a7737a87@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 2:06 PM, Paul Menage <menage@google.com> wrote:
> On Thu, Feb 28, 2008 at 1:33 PM,  <serge@hallyn.com> wrote:
>  >
>  >  You said the set of files belong to cgroup itself is likely to increase
>  >  - do you have some candidates in mind?
>
>  Nothing concrete right now. One example that I already proposed was
>  the "cgroup.api" file but that's shelved for now, until such time as I
>  actually propose the binary API that it was intended to help support.
>

One likely new file that people agreed a while ago could be useful
would be a "procs" file, similar to "tasks", but acting (and
reporting) on thread groups rather than individual tasks.

Paul
