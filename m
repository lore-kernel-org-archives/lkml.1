Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYCCRlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYCCRlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760175AbYCCRft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:35:49 -0500
Received: from ns.suse.de ([195.135.220.2]:44192 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759877AbYCCRfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:35:48 -0500
Date: Mon, 3 Mar 2008 18:35:47 +0100
From: Andi Kleen <ak@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA
	support - alternatives"
Message-ID: <20080303173546.GE9021@bingen.suse.de>
References: <47C86D7A.5030608@goop.org> <47C8717F.3030009@zytor.com> <47C87488.9030205@goop.org> <20080303173057.GA14598@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303173057.GA14598@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Would ioremap() be a good alternative ?

One of the early attempts at patching ro data used ioremap. Unfortunately
it was a little buggy and was thus reverted, but that were only detail
problems, nothing fundamental of the approach.

-Andi

