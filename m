Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbXKFGQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbXKFGQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXKFGP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:15:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:57900 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXKFGPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t0LsYAH9bVu3HTvYZ17io9+KeF2ZGrthJM/OUDdRMUvbsvSwh+fMZEVFFxN/ohGO5dtAhY/y7UUVegIOG045tE9xPc3DC+cjji7Sv8ZF+S4vCrjln6IYuvavSYbrNBDrDkqG2OxC/BYiG5NXPwwjzrRS3lxZgGF8Q8aSlYhVaUA=
Message-ID: <b6a2187b0711052215x26b1e7e5r9d5af339d21e854f@mail.gmail.com>
Date: Tue, 6 Nov 2007 14:15:54 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 1/2] slub: fix leakage
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <Pine.LNX.4.64.0711051036250.13139@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0711031935510.15611@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0711031247250.5828@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0711031950300.17078@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0711031253580.6080@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0711032007060.17942@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0711031326450.6227@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0711041103030.8179@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0711051036250.13139@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2007 2:45 AM, Christoph Lameter <clameter@sgi.com> wrote:

> 1. We can avoid going back to the page allocator for awhile since we will
> find the almost free slab if the current slab is exhausted.

Does this impact SLAB as well? I'm getting out of memory with kernel
2.6.21, 2.6.22 and 2.6.23, so I'm stuck with 2.6.20-15 for systems
running Oracle. It only happens with lots of activities.

Jeff.
