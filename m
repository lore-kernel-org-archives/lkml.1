Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZAFDtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZAFDtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZAFDtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:49:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35192 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZAFDtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:49:01 -0500
Date: Tue, 6 Jan 2009 03:48:45 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: crquan@gmail.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Re: [git pull] device-mapper patches for 2.6.29
Message-ID: <20090106034845.GD3512@agk.fab.redhat.com>
Mail-Followup-To: crquan@gmail.com, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Milan Broz <mbroz@redhat.com>
References: <20081010125159.GK5098@agk.fab.redhat.com> <20090105191824.GP5098@agk.fab.redhat.com> <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain> <91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com> <20090106032118.GC3512@agk.fab.redhat.com> <91b13c310901051932p1343f9eei1db5534e6e10d238@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91b13c310901051932p1343f9eei1db5534e6e10d238@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:32:51AM +0800, Cheng Renquan (程任全) wrote:
> On Tue, Jan 6, 2009 at 11:21 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> > On Tue, Jan 06, 2009 at 11:15:58AM +0800, Cheng Renquan (程任全) wrote:
> >> So now maybe we can add a null macro to module_refcount if
> >> CONFIG_MODULE_UNLOAD undefined?
> > Do we even need the test at all?
 
> So you mean add "#ifdef CONFIG_MODULE_UNLOAD ..." to dm-target.c? I
> can do that, but I really don't know a better solution without
> conditional compiling?
 
I mean under what set of circumstances could the test of the module refcount
here fail, and if the test was simply removed are there any cases where that
would matter?

Alasdair
-- 
agk@redhat.com
