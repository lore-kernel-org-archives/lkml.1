Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbXIEWml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbXIEWml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 18:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbXIEWmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 18:42:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:5387 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbXIEWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 18:42:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jsth1j7bPq/z15jLWzDPmwoMZHdmm6+7bhdwqm8Qg27+dr82qat6qm37loqI7dttr93HteJ5xR+DFXFE7w4nm4NxSdK0WFfWF2/BRRKHbMLVDWsAf6wjhC4hL3wGwayJJZLWoWF2b8iLwtsMzVk4AXJr44QxR6zA3EyQKXqDdBU=
Message-ID: <86802c440709051542w1950e28bhb21cf5c380527a6e@mail.gmail.com>
Date: Wed, 5 Sep 2007 15:42:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Cc: "Arne Georg Gleditsch" <argggh@dolphinics.no>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070905161300.GE22086@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070903081736.288288000@amd.com>
	 <20070903013157.72c94891@laptopd505.fenrus.org>
	 <20070903091718.GB22144@alberich.amd.com>
	 <20070903043319.7573875b@laptopd505.fenrus.org>
	 <20070903154734.GC22086@alberich.amd.com> <46DE45A2.40403@zytor.com>
	 <20070905084427.GE6409@erda.amd.com> <46DE80F0.4000706@zytor.com>
	 <kjmd4wxz822.fsf@pelargir.dolphinics.no>
	 <20070905161300.GE22086@alberich.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/07, Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> On Wed, Sep 05, 2007 at 01:05:25PM +0200, Arne Georg Gleditsch wrote:
> > "H. Peter Anvin" <hpa@zytor.com> writes:
> > > You're missing the point.   How will the PCI bus transactions be
> > > different when using MMCONFIG versus your extended CF8 version?
> >
> > Conceivably this is useful if the IO hub does not support MMCONFIG
> > accesses.  The AMD 8111 does not, as far as I can see.  At least I
> > have an Opteron system where MMCONFIG is not supported, and I assume
> > it's because the 8111 doesn't provide it.  I don't know if this is
> > going to be a realistic scenario for Barcelona systems.

mmconfig is set in NB ( in new CPU), Do we still need to set mmconfig
in SB like mcp55?

YH
