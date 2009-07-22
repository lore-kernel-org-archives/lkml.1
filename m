Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZGVCrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZGVCrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZGVCrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:47:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55855 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZGVCrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:47:22 -0400
Date: Tue, 21 Jul 2009 21:57:07 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Ted Merrill <atheros@embuildsw.com>
Subject: Re: khttpd fate
Message-ID: <20090722015706.GB6025@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Kyle McMartin <kyle@mcmartin.ca>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-kernel@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Ted Merrill <atheros@embuildsw.com>
References: <43e72e890907171815x3a85c788k1b4c0f72954db9e5@mail.gmail.com> <20090722002039.GF11051@bombadil.infradead.org> <4A665F09.7050104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A665F09.7050104@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 05:36:25PM -0700, H. Peter Anvin wrote:
 > On 07/21/2009 05:20 PM, Kyle McMartin wrote:
 > > 
 > > I think it kind of got replaced by tux, which Red Hat shipped for a
 > > while, but has been dropped now. I seem to recall davej mentioning a
 > > while ago that apache had gotten much better at serving static content,
 > > which is what khttpd/tux were very good at.
 > > 
 > 
 > Also, lighttpd does really well, all in userspace.  After all, static
 > http serving really is mostly a bit of header parsing followed by
 > sendfile(), so as long as a user-space process doesn't just sit on a
 > bunch of memory it can be done very cheaply.
 
I think the rise of dynamically generated content was a big thing that
killed it off. With more and more of the web getting ajaxified, and the
php etc being offloaded to apache anyway, it just makes more sense to
have one webserver do everything as long as it's "fast enough".

I wrote something up on this a few years back when I made the decision to
drop Tux from the Fedora kernel. http://kernelslacker.livejournal.com/tag/tux

	Dave

