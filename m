Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZC0RNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZC0RNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZC0RNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:13:13 -0400
Received: from gw.goop.org ([64.81.55.164]:46397 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZC0RNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:13:13 -0400
Message-ID: <49CD0926.8080503@goop.org>
Date: Fri, 27 Mar 2009 10:13:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp,
       ian.campbell@citrix.com
Subject: Re: [PATCH 0/5] swiotlb: changes for powerpc/highmem
References: <1237930126-6741-1-git-send-email-beckyb@kernel.crashing.org>
In-Reply-To: <1237930126-6741-1-git-send-email-beckyb@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Becky Bruce wrote:
> This is a series of fairly minor patches that get swiotlb working
> on 32-bit powerpc systems with HIGHMEM, plus some cleanup of the
> outdated comments in the code.  I've made a couple of things
> weak that ppc needs to override, and have changed the prototypes
> for a couple of functions to include the hwdev pointer, which
> we need to ppc to convert bus addresses to and from phys/virt
> addresses.  I've also fixed a build warning I've been seeing on
> ppc.
>
> I have not tested this in any way on any non-ppc platforms,
> so commentary/testing from x86/ia64 folks is greatly 
> appreciated.
>   

This works fine for me under Xen.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
