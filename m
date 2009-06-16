Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZFPTY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZFPTY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZFPTYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:24:22 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50751 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754247AbZFPTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:24:21 -0400
Date: Tue, 16 Jun 2009 15:23:50 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0906161522370.29941@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>  <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> 
 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>  <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>  <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de> <1245101567.12400.38.camel@pasglop>
 <alpine.DEB.1.10.0906161104480.26093@gentwo.org> <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Linus Torvalds wrote:

> > Could we add more bootup states to enum system_states?
>
> I'd rather get rid of the whole slab_is_available() thing entirely.

slab_is_available is necessary for slab bootstrap but if we use
system_state for this then its not necessary anymore.

> If that isn't true yet, then we should make it more true.

Right.

> IOW, we should strive for not having any code that is at all confused
> about whether it can do slab allocations or not.

So encode the stage of boot up in system_state? Maybe add documentation to
explan what is possible at these states and what is not?

