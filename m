Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbYAYTCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbYAYTCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbYAYTCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:02:37 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:34897 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbYAYTCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:02:36 -0500
Date: Fri, 25 Jan 2008 11:19:02 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
In-reply-to: <479A30A3.7050305@goop.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801251119.02565.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <47993F1A.5070408@goop.org> <20080125110935.GA20026@elte.hu>
 <479A30A3.7050305@goop.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 10:55:31 am Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> >
> >   
> >> [PATCH] x86: trim ram need to check if mtrr is there v3
> >>     
> >
> >   
> >>> H. Peter Anvin wrote:
> >>> Looks like the code doesn't check that the CPU *has* MTRRs...
> >>>       
> >> so more strict check if mtrr is there really.
> >> bail out if mtrr all blank when qemu cpu model is used
> >>
> >> and check if is AMD as early
> >> also remove 4G less check, according to hpa.
> >>     
> >
> > thanks, applied. Shouldnt we put in an exception for when there is MTRR 
> > support, but they dont cover anything. Still emit a warning - but 
> > booting up real slow is still better than losing all of RAM and crashing 
> >   
> 
> The problem is re-occuring for me with current x86.git.  Looks like v2 
> did the trick, and v3 is broken...

so the ram size less 4g is way out for your case.

again, can you post /proc/mtrrs with v2 patch?

Thanks

YH
