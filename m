Return-Path: <linux-kernel-owner+w=401wt.eu-S1946581AbXD3RG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946581AbXD3RG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946583AbXD3RG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:06:26 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:33599 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946582AbXD3RGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:06:24 -0400
Subject: Re: [PATCH 04/12] i386 voyager: Use modern techniques to setup and
	teardown low identiy mappings.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	 <m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	 <m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
	 <m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
	 <m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 12:06:17 -0500
Message-Id: <1177952777.3674.41.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 09:57 -0600, Eric W. Biederman wrote:
> This is a trivial and hopefully obviously correct patch to setup
> and teardown the identity mappings the way the rest of arch/i386
> does.
> 
> My new page table setup code will break some assumptions below so
> this is my attempt to keep voyager working. 

It works for the 586 beasts ... I'll dig out some 486 cards and test
them later.  Thanks,

James


