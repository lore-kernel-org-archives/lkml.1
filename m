Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYADM1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYADM1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYADM0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:26:42 -0500
Received: from mail.suse.de ([195.135.220.2]:39545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYADM0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:26:40 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [4/16] Add /proc/irq/*/spurious to dump the spurious irq debugging state
Date: Fri, 4 Jan 2008 13:22:01 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <20080103154217.E57A714DDB@wotan.suse.de> <20080104085845.GD28740@elte.hu>
In-Reply-To: <20080104085845.GD28740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801041322.01190.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ix it:

You mean the new line after local variables?

I never liked this rule. Newlines may make sense on very large functions, but
on short functions they just obscure more. And I actually checked CodingStyle now 
and it says nothing about that. So please apply the patch anyways.

-Andi

> > +static int irq_spurious_read(char *page, char **start, off_t off,
> > +				  int count, int *eof, void *data)
> > +{
> > +	struct irq_desc *d = &irq_desc[(long) data];
> > +	return sprintf(page, "count %u\n"
> > +			     "unhandled %u\n"
> 
> 	Ingo
> 


