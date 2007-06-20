Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbXFTXJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbXFTXJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXFTXJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:09:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbXFTXJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:09:34 -0400
Date: Wed, 20 Jun 2007 19:07:51 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
Message-ID: <20070620230751.GA15092@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ian McDonald <ian.mcdonald@jandi.co.nz>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>,
	"Darrick J. Wong" <djwong@us.ibm.com>, Andi Kleen <ak@suse.de>,
	Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
	William Cohen <wcohen@redhat.com>,
	"S. P. Prasanna" <prasanna@in.ibm.com>,
	Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
	Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
	Rudolf Marek <r.marek@assembler.cz>,
	Soeren Sonnenburg <kernel@nn7.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <467543FA.60905@googlemail.com> <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com> <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 03:38:06PM -0700, Linus Torvalds wrote:

 > And yes, that patch already got merged. However, the patch to *allow* 
 > Kprobes with DEBUG_RODATA is not, and will not be. It's not a regression, 
 > and quite frankly, I don't think I would even want that patch.
 > 
 > Kprobes fundamntally disagrees with DEBUG_RODATA, there's no point in 
 > "working around it". Better just admit it.

Surely the fundamental disagreement is only due to DEBUG_RODATA
covering write-protection of both .text, and .rodata  ?
I can see value in having a kernel that supports kprobes, whilst
at the same point, raising red flags if something writes into
a const string. With my distro kernel maintainer hat on, I always
hate these 'pick one' decisions, because I always get convincing
arguments from proponents of both sides.

Was it always this way?  I thought DEBUG_RODATA initially just
covered, well.. rodata.    And kprobes only wants to change .text
doesn't it ?

	Dave

-- 
http://www.codemonkey.org.uk
