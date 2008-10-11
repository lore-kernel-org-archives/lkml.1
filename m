Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbYJKOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbYJKOKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYJKOKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:10:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYJKOKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:10:32 -0400
Message-ID: <48F0B3CD.2010705@zytor.com>
Date: Sat, 11 Oct 2008 07:10:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu> <48D95A8F.10705@zytor.com> <48D95ECC.9010107@knaff.lu> <48D96013.1070507@zytor.com> <48D966E4.7080200@knaff.lu> <48D96B58.6080604@zytor.com> <48D96C60.6000104@knaff.lu> <48EE4302.2010404@zytor.com> <48EEC7D1.80404@knaff.lu> <48EFC9A0.5070907@zytor.com> <48F0559C.1040705@knaff.lu>
In-Reply-To: <48F0559C.1040705@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> 
> So, leaving out the x86-specific change
> (arch/x86/boot/compressed/misc.c) in the first change, would force to
> leave that change out of lib/inflate.c as well (or else, the
> above-listed items would be doubly defined). But, if I left out these
> changes of lib/inflate.c, I'd need to leave them out of and
> init/do_mounts_rd.c and init/initramfs.c too (or else the above-listed
> items would not be defined at all in that situation). Can you suggest a
> solution? I could theoretically break that dependency chain using an
> #ifdef (as was the case until patch 3), but apparently #ifdef's are
> highly frowned upon. Or was it just the name of the ifdef ("NEW_CODE")
> that you objected to? Another option would be to (temporarily) keep 2
> copies of lib/inflate.c around, but somehow that doesn't feel right.
> 
> So can you suggest some way out of the situation?
> 

Temporarily leaving two copies would work, as would be leaving in an 
#ifdef as long as it is gone by the end of the patch series.

	-hpa
