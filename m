Return-Path: <linux-kernel-owner+w=401wt.eu-S1946288AbXD3Q1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946288AbXD3Q1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946092AbXD3Q1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:27:30 -0400
Received: from ns.suse.de ([195.135.220.2]:47256 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946224AbXD3Q11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:27:27 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 08/12] i386: Convert the boot time page tables to the kernels native format.
Date: Mon, 30 Apr 2007 18:26:57 +0200
User-Agent: KMail/1.9.6
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com> <m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com> <m1ejm14z5f.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ejm14z5f.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301826.57920.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 18:15:08 Eric W. Biederman wrote:
> 
> Currently we have a lot of special case code and a lot of limitations
> because we cannot count on the initial boot time page tables being in
> the format our page table handling routines know how to manipulate.
> So this patch rewrites the code that initializes our boot time page
> tables.

Sounds reasonable, but for post .22

-Andi
