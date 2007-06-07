Return-Path: <linux-kernel-owner+w=401wt.eu-S936390AbXFGAJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936390AbXFGAJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXFGAJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:09:10 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40571 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbXFGAJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:09:09 -0400
Message-ID: <46674C96.7090104@zytor.com>
Date: Wed, 06 Jun 2007 17:08:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
References: <20070606225837.654272428@goop.org> <20070606230922.476662240@goop.org> <4667462A.2010404@zytor.com> <466749C8.2010700@goop.org>
In-Reply-To: <466749C8.2010700@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> I'm not sure I fully understand the mechanism you're proposing.  You
> have the 16-bit setup code, the 32-bit decompressor, and an ELF.gz. Once
> the decompressor has extracted the actual ELF file, are you proposing
> that it properly parse the ELF file and follow its instuctions to put
> the segments in the appropriate places, or are you assuming that the
> decompressor can just skip that part and plonk the ELF file where it wants?
> 
> In other words, do you see the Phdrs as being descriptive or prescriptive?
> 

I was thinking prescriptive, having the decompressor read the output
stream and interpret it as ELF.  I guess a descriptive approach could be
made to work, too (I haven't really thought about that avenue of
approach), but the prescriptive model seems more powerful, at least to me.

	-hpa
