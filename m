Return-Path: <linux-kernel-owner+w=401wt.eu-S1767710AbXCJB30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767710AbXCJB30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767711AbXCJB30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:29:26 -0500
Received: from mail15.syd.optusnet.com.au ([211.29.132.196]:52054 "EHLO
	mail15.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767710AbXCJB3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:29:25 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 12:28:38 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703101134.26313.kernel@kolivas.org> <20070310004948.GN10394@waste.org>
In-Reply-To: <20070310004948.GN10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101228.38923.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 11:49, Matt Mackall wrote:
> On Sat, Mar 10, 2007 at 11:34:26AM +1100, Con Kolivas wrote:
> > Ok, so some of the basics then. Can you please give me the output of 'top
> > -b' running for a few seconds during the whole affair?
>
> Here you go:
>
> http://selenic.com/baseline
> http://selenic.com/underload
>
> This is with 2.6.20+rsdl+tickfix at HZ=250.
>
> Something I haven't mentioned about my setup is that I'm using ccache.
> And it turns out disabling ccache makes a large difference. Going to
> switch back to a NO_HZ kernel and see what that looks like.

Your X is reniced to -10 so.... try again with X nice 0 please.

-- 
-ck
