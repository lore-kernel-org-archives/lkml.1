Return-Path: <linux-kernel-owner+w=401wt.eu-S1762037AbYBALLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762037AbYBALLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbYBALK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:10:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbYBALK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:10:57 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Are Section mismatches out of control?
Date: Fri, 1 Feb 2008 12:10:52 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080201104718.GA11717@uranus.ravnborg.org>
In-Reply-To: <20080201104718.GA11717@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011210.52655.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 11:47:18 Sam Ravnborg wrote:
> James said in a related posting that the Section mismatch
> warnings were getting out of control.

My question is: where are crashes? If the sections were
really in such bad shape and since we poison (and sometimes
even unmap) init after boot we should in theory see a lot 
of oops reports from this if there were really accesses to
them after boot.

Where are they?


> The total figure for this build is 106 warnings.

The interesting question is how many true bugs are in these warnings.

-Andi
