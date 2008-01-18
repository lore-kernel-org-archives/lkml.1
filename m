Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbYARVSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbYARVSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761469AbYARVSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:18:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:43159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761017AbYARVSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:18:04 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: CPA self-test failures
Date: Fri, 18 Jan 2008 22:18:00 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47911646.8030203@goop.org>
In-Reply-To: <47911646.8030203@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801182218.00103.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 22:12:38 Jeremy Fitzhardinge wrote:
> When booting under KVM, I get a pile of messages out of the CPA 
> self-test.  It makes it to usermode OK though.

Yes known problem. On some systems the self test interacts badly
with the split mappings created by the PAT code I think. I don't have a fix yet.
But you can ignore it for now -- should be harmless. Or disable CONFIG_CPA_DEBUG.

-Andi
