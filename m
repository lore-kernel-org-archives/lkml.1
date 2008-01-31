Return-Path: <linux-kernel-owner+w=401wt.eu-S1765446AbYAaHj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765446AbYAaHj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYAaHjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:39:18 -0500
Received: from mail.suse.de ([195.135.220.2]:48170 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbYAaHjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:39:17 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: system without RAM on node0 boot fail
Date: Thu, 31 Jan 2008 08:39:10 +0100
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801302026.27130.yinghai.lu@sun.com> <86802c440801302306g2a1ae11h52b883eed79b7e96@mail.gmail.com> <47A17727.6090302@zytor.com>
In-Reply-To: <47A17727.6090302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801310839.10638.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 08:22:15 H. Peter Anvin wrote:
> Yinghai Lu wrote:
> > On Jan 30, 2008 10:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> Christoph Lameter wrote:
> >>> x86 supports booting from a node without RAM?
> > 
> > it is a two sockets system. only 4G RAM installed on node1.
> > 
> 
> "Node 1" is the boot CPU, though, right?
> 
> I don't know if the spec requires node 0 to be the boot node.  Probably not.

There is no spec I know of that completely defines "nodes" on x86.
Actually I think on Linux calls them that.

There is the ACPI 3.0 SRAT spec that defines memory affinity,
but I don't think it has any requirements about where the memory must be.

Even if there was a spec people who actually put in DIMMs tend
to violate it. It seems to be not totally uncommon to just 
stuff them all into the same corner of the motherboard to give 
a "tidy appearance" (for non physicists :-) and that usually results in 
memory less nodes.

Anyways this area is something that regresses regularly. I had
fixed it several times and tested all cases on SimNow, but after
some time it tends to bit rot again unfortunately. The people who
usually test kernels probably know where to put the DIMMs in.

Probably just happened again.

-Andi


