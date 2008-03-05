Return-Path: <linux-kernel-owner+w=401wt.eu-S935316AbYCEAHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316AbYCEAHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935005AbYCEAGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:06:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:53828 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934919AbYCEAGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:06:36 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: preempt bug in set_pmd_pfn?
Date: Wed, 5 Mar 2008 01:06:31 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47CDBB87.8090906@goop.org>
In-Reply-To: <47CDBB87.8090906@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803050106.31609.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Won't this leave a stale tlb on the old processor?

__set_fixmap should be only used in early boot, so it's always
on CPU 0

-Andi
