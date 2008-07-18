Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbYGRXQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbYGRXQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYGRXQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:16:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYGRXQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:16:06 -0400
Message-ID: <48812425.4050300@zytor.com>
Date: Fri, 18 Jul 2008 16:15:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: clean up pgd_{c,d}tor
References: <4880AD11.76E4.0078.0@novell.com>
In-Reply-To: <4880AD11.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Giving pgd_ctor() a properly typed parameter allows eliminating a local
> variable. Adjust pgd_dtor() to match.
> 
> Also, pgd_ctor()'s clearing of the memory is redundant with the
> GFP_ZERO used for allocating it.

This patch appears stale.

	-hpa
