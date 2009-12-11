Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbZLKT0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbZLKT0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZLKTZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:25:55 -0500
Received: from waste.org ([173.11.57.241]:42175 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbZLKTZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:25:54 -0500
Subject: Re: hwrng: virtio - Rename driver object to remove section
 mismatch warning
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091211153658.GA1207@gondor.apana.org.au>
References: <20091211153658.GA1207@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 13:25:57 -0600
Message-ID: <1260559557.24459.1320.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 23:36 +0800, Herbert Xu wrote:
> Hi:
> 
> Finally found the cause of the section mismatch warning in hwrng.
> Apparently in addition to __devexit_p we now have to name the
> variable in a certain way.

That's fairly appalling. Any idea why?

-- 
http://selenic.com : development and support for Mercurial and Linux


