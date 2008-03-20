Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYCTWpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYCTWpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYCTWpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:45:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:22231 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYCTWpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JnGYdC2Cf171/0G4TsyfJDas2Hx4IqQLJw8EoTXfWijpTmbth64ifiVFc6Rzi+m5ffUBsiaWyErdySSUMlKcS30ApLfEiqKTCrYGb4M+iuE9RDuH00jJynQ5E98jxw5ZjAefjt40DdvrQ3sJSesojLyfuX/BEH6XjaICYIOXvAE=
Message-ID: <b1bc6a000803201545i2eaecc20r921b77e2e60e8911@mail.gmail.com>
Date: Thu, 20 Mar 2008 14:45:01 -0800
From: "adam radford" <aradford@gmail.com>
To: "Matteo Tescione" <matteo@rmnet.it>
Subject: Re: max_sectors_kb problem
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <C4077491.650A%matteo@rmnet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <C4077491.650A%matteo@rmnet.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 4:55 PM, Matteo Tescione <matteo@rmnet.it> wrote:
> Hello Folks,
>
>  I'm running 2.6.24.3 kernel with the 3ware 9650se 8port in raid10 with 256K
>  of stripesize.
>  The question is: why linux kernel (2.6.24 but it's the same in older
>  kernels) see only 128K as it's max_sectors_kb ?
>  It's limited by max_hw_segments_kb which i think should be 256 with a 256 k
>  stripe.
>  It seems hardcoded somewhere, altough in 3w-9xxx.c i can't find it.
>  I'm running firmware FE9X 3.08.02.007 and driver version  2.26.02.010
>  Can someone help me?

This is hardcoded in the 3w-9xxx driver to 128k.   The controller firmware
is only guaranteed to work with that size.  If you change it, you may
incur data corruption, hangs, or both.  Hacker beware.

-Adam
