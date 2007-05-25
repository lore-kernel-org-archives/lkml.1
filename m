Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbXEYMiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbXEYMiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXEYMh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:37:59 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:52812 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761369AbXEYMh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eMj0V0DP6sJrwiIbQT+rXN61W6DMtBoKHEyRflWKVSV4xc6yHzOuf2NU6nHHW163yIkjdYLxGbaDlyOgJfDF4qGgfpeDeapmxyOmD/pHtuia5R6T6htPdNe/9hs0l/YhDfVPJSeDbS/T0dUjKVC+AkubK1hDxt/D2NuXgdJyWFc=
Message-ID: <a781481a0705250537o768c609evaf32d517444f7aca@mail.gmail.com>
Date: Fri, 25 May 2007 18:07:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 4
Cc: "Nitin Gupta" <nitingupta910@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
In-Reply-To: <1180095000.5864.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
	 <1180095000.5864.48.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 5/25/07, Richard Purdie <richard@openedhand.com> wrote:
> On Fri, 2007-05-25 at 17:15 +0530, Nitin Gupta wrote:
> > Richard, can you please provide perf. results for this patch also?
> > Also, can you please mail back latest version of your LZO patch? In
> > meantime, I will try to include benchmarking support to the
> > 'compress-test' module.
>
> This version is 15% slower at decompression and about equal on
> compression.

I hope you tested your _safe variant against this, Nitin has done away
with the _unsafe version in this patch. Also, are you using your crypto
lzo-support + tcrypt changes ( http://lkml.org/lkml/2007/5/1/303 ) to
benchmark these?

> I am however still strongly of the opinion that we should just use the
> version in -mm (which is my latest version).

Right, if the difference is anything >10%, code cleanup does lose
its attractiveness.

Satyam
