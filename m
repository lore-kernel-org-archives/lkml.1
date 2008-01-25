Return-Path: <linux-kernel-owner+w=401wt.eu-S1764185AbYAYIB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764185AbYAYIB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbYAYHus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:50:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:59118 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762990AbYAYHuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kXN4DbG8o08APEzZMfXaqmTDBav/FFQr3U7hM1auNhWl78O46rfPuYlIunoXuY7+bRJlC+1n2F9OLRwdYSHNuvmQJtKKAkEngu11AnMib7eqRvO4uEnN/jfny1l18f2QV3LGmaKxqRrxr8Mb9wBZh1IqhSMsRBH2aYwP7hm9P4c=
Message-ID: <86802c440801242350g3b170e35m8c02d8e26d5d1743@mail.gmail.com>
Date: Thu, 24 Jan 2008 23:50:45 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v2
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47997735.1020501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47993F1A.5070408@goop.org> <4799400C.1060102@zytor.com>
	 <200801241947.55223.yinghai.lu@sun.com> <47997735.1020501@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2008 9:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
> >> H. Peter Anvin wrote:
> >> Looks like the code doesn't check that the CPU *has* MTRRs...
> >
> > so check it mtrr is there, also check if mem less 4G and is AMD as early
>
> Why the check for < 4 GB?  The same thing applies to memory below the 4
> GB limit -- in fact, we've had a number of that kind of systems in the past.

then we could remove that.

YH
