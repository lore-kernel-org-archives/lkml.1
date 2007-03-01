Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbXCAOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbXCAOH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXCAOH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:07:29 -0500
Received: from kanga.kvack.org ([66.96.29.28]:50779 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbXCAOH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:07:28 -0500
Date: Thu, 1 Mar 2007 09:06:48 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de,
       akpm@linux-foundation.org, judith@linux-foundation.org
Subject: Re: [PATCH RFC 0/5] hard_smp_processor_id overhaul
Message-ID: <20070301140648.GX26583@kvack.org>
References: <1172733373.1498.264.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1172733373.1498.264.camel@sebastian.intellilink.co.jp>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:16:13PM +0900, Fernando Luis Vázquez Cao wrote:
> As a consequence, the hardcoding of hard_smp_processor_id() to 0 on UP
> systems (see "linux/smp.h") is not correct.
> 
> This patch-set does the following:
> 
> 1- Remove hardcoding of hard_smp_processor_id on UP systems.

NAK.  This has to be configurable, as many embedded systems don't even 
have APICs.  Please rework the patch set so that there is not any overhead 
for existing UP systems.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
