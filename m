Return-Path: <linux-kernel-owner+w=401wt.eu-S965531AbXFGAV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531AbXFGAV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbXFGAVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:21:20 -0400
Received: from gw.goop.org ([64.81.55.164]:55206 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbXFGAVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:21:20 -0400
Message-ID: <46674F68.6030100@goop.org>
Date: Wed, 06 Jun 2007 17:20:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
References: <20070606225837.654272428@goop.org> <20070606230922.476662240@goop.org> <4667462A.2010404@zytor.com> <466749C8.2010700@goop.org> <46674C96.7090104@zytor.com>
In-Reply-To: <46674C96.7090104@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I was thinking prescriptive, having the decompressor read the output
> stream and interpret it as ELF.  I guess a descriptive approach could be
> made to work, too (I haven't really thought about that avenue of
> approach), but the prescriptive model seems more powerful, at least to me.

Certainly, but much harder to implement.  The ELF parser needs to be
prepared to move itself around to get out of the way of the ELF file. 
It's a fairly large change from how it works now.

I was thinking of making the ELF file entirely descriptive, since its
just a set of ELF headers inserted into the existing bzImage structure,
and it still relies on the bzImage being build properly in the first place.

    J
