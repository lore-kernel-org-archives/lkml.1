Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZFXWLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZFXWLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZFXWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:11:09 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:58243 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZFXWLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r821wEsuQiUeJnVGXdM4/RivDMOLQGSvgudYvsaxZ4NwHEY0cs2fVCap6NPMrhSsLT
         axffp/DFGZjTWB0Q8qoeRWtf1gdw0NiGcF6nVGO7nYjYSwTxNibZPSiGzvigAGwhg1c0
         IthuyQjTzr64H6frCsyRywxlhGLY+743cTlGg=
MIME-Version: 1.0
In-Reply-To: <4A42A2FD.1060401@lwfinger.net>
References: <1245845787.3093.3.camel@localhost.localdomain>
	 <20090624175513.GE7239@us.ibm.com>
	 <20090624112849.55b38fff@jbarnes-g45>
	 <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>
	 <20090624194839.GG7239@us.ibm.com> <4A4286F8.9020501@lwfinger.net>
	 <86802c440906241432l6d601f76sf2a413d6e19079e6@mail.gmail.com>
	 <4A429DAA.3010303@lwfinger.net>
	 <86802c440906241444g1aabcc5rb2d189dca0965e36@mail.gmail.com>
	 <4A42A2FD.1060401@lwfinger.net>
Date: Wed, 24 Jun 2009 15:11:08 -0700
Message-ID: <86802c440906241511i3d534723u4dfdef9448b54bb9@mail.gmail.com>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 3:04 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> Yinghai Lu wrote:
> node 0 link 0: mmio [a0000, bffff]
> node 0 link 0: mmio [c0000000, dfffffff]
> node 0 link 0: mmio [e0000000, efffffff]
> node 0 link 0: mmio [f0000000, fe0bffff]
> bus: [00,ff] on node 0 link 0
> bus: 00 index 0 io port: [0, ffff]
> bus: 00 index 1 mmio: [a0000, bffff]
> bus: 00 index 2 mmio: [c0000000, fcffffffff]

that is read from pci config.

and only one HT chain is there. so there is no point to use _CRS for them.

please let me check if we could could have patch to deselect that.

YH
