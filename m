Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203Ab0A1Vur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0A1Vur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 16:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009Ab0A1Vuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 16:50:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:44977 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0A1Vuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 16:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rei0sZDzEpiGs/Lbx+KpfywsHApXzG5vCEOwfQncdeVcsov5zzG2ilG7rjYGvh5TF/
         0IEPLTHDQMXNz/UmxBfwoM7Mn9E+T7eANWolmoW8D/bk03pgVH5UJ0pnqBXkjJS1C4kM
         hbVzqN9X0ndtSsxeLF10Gr7yMqv9sa5uNb3sk=
Date: Thu, 28 Jan 2010 22:50:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] x86,hw_breakpoint,kgdb: kgdb to usehw_breakpointAPI
Message-ID: <20100128215040.GF18683@nowhere>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-2-git-send-email-jason.wessel@windriver.com> <20100128171050.GA18683@nowhere> <4B61CD14.7000901@windriver.com> <20100128200418.GC18683@nowhere> <4B61F34A.20305@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61F34A.20305@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 02:27:54PM -0600, Jason Wessel wrote:
> I'll move this to the gdbstub in the next merge window, because it looks
> like there might also be other archs that gain the
> arch/*/kernel/hw_breakpoint.c.


Yeah, PowerPc, S390 and ARM are in progress.


> I can also move the logic for the install / remove to be owned by either
> hw_breakpoint.c or the debug core because that will become arch
> independent as well as more archs pickup the hw_breakpoint.c methodology.



Indeed.

