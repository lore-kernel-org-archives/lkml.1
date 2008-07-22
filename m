Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYGVSAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYGVSAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYGVSAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:00:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbYGVSAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:00:44 -0400
Date: Tue, 22 Jul 2008 14:00:15 -0400
From: Rik van Riel <riel@redhat.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
 (part1: use kprobe symbol_name/offset instead of address)
Message-ID: <20080722140015.37628ea4@bree.surriel.com>
In-Reply-To: <20080717213355.GJ18295@redhat.com>
References: <487E78ED.30804@redhat.com>
	<1216249383.3358.69.camel@localhost.localdomain>
	<487E8CE4.70105@redhat.com>
	<1216259391.3358.85.camel@localhost.localdomain>
	<1216304290.5515.11.camel@localhost.localdomain>
	<1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
	<y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
	<1216325546.5515.63.camel@localhost.localdomain>
	<20080717202634.GI18295@redhat.com>
	<1216328769.5515.78.camel@localhost.localdomain>
	<20080717213355.GJ18295@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 17:33:55 -0400
"Frank Ch. Eigler" <fche@redhat.com> wrote:

> Yes, that is generally desirable - each case is usually a question of
> cost/benefit.  One significant requirement for us is to keep working
> with older kernels.

You will have to weigh that against the benefits of making
systemtap generally useful for kernel developers, which
would result in a more active systemtap community and,
eventually, more available scripts and easier end user
functionality.

If a project is not aimed squarely at the developers who 
could give the project critical mass, it is essentially 
doomed.

-- 
All rights reversed.
