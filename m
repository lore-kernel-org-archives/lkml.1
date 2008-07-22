Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYGVSMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYGVSMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYGVSMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:12:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYGVSMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:12:39 -0400
Date: Tue, 22 Jul 2008 14:11:02 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs (part1: use kprobe symbol_name/offset instead of address)
Message-ID: <20080722181101.GC9508@redhat.com>
References: <487E8CE4.70105@redhat.com> <1216259391.3358.85.camel@localhost.localdomain> <1216304290.5515.11.camel@localhost.localdomain> <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain> <y0m7ibkjrcj.fsf@ton.toronto.redhat.com> <1216325546.5515.63.camel@localhost.localdomain> <20080717202634.GI18295@redhat.com> <1216328769.5515.78.camel@localhost.localdomain> <20080717213355.GJ18295@redhat.com> <20080722140015.37628ea4@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722140015.37628ea4@bree.surriel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jul 22, 2008 at 02:00:15PM -0400, Rik van Riel wrote:
> [...]
> > Yes, that is generally desirable - each case is usually a question of
> > cost/benefit.  One significant requirement for us is to keep working
> > with older kernels.
> 
> You will have to weigh that against the benefits of making
> systemtap generally useful for kernel developers [...]

Understood & agreed, Rik.  If an issue arises where there is genuine
conflict between kernel-developer-usability and something else, we'll
try to solve it favouring the former if at all possible.

(The kprobes addressing argument cannot reasonably be placed into this
category.)


- FChE
