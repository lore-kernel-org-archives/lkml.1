Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbZIPPIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbZIPPIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbZIPPIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZIPPIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:08:16 -0400
Date: Wed, 16 Sep 2009 11:07:42 -0400
From: Dave Jones <davej@redhat.com>
To: Kurt Roeckx <kurt@roeckx.be>
Cc: David Rientjes <rientjes@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
Message-ID: <20090916150742.GA2493@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kurt Roeckx <kurt@roeckx.be>, David Rientjes <rientjes@google.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Testers <kernel-testers@vger.kernel.org>,
	Mark Langsdorf <mark.langsdorf@amd.com>,
	Naga Chumbalkar <nagananda.chumbalkar@hp.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <200909080112.14997.rjw@sisk.pl> <20090908194653.GA3517@roeckx.be> <200909102259.15144.rjw@sisk.pl> <alpine.DEB.1.00.0909151642100.24059@chino.kir.corp.google.com> <20090916064708.GA25472@roeckx.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916064708.GA25472@roeckx.be>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 08:47:08AM +0200, Kurt Roeckx wrote:
 > On Tue, Sep 15, 2009 at 04:45:37PM -0700, David Rientjes wrote:
 > > On Thu, 10 Sep 2009, Rafael J. Wysocki wrote:
 > > 
 > > > > So I did a biset, and this is the result:
 > > > > $ git bisect good
 > > > > 0e64a0c982c06a6b8f5e2a7f29eb108fdf257b2f is first bad commit
 > > 
 > > 0e64a0c has this cleanup, which isn't equivalent to the previous code:
 > 
 > Please look at the patch I attached to the bug report.  There is
 > other code that is not equivalent.  It's in comment #17:
 > http://bugzilla.kernel.org/show_bug.cgi?id=13780#c17
 > 
 > And the patch itself:
 > http://bugzilla.kernel.org/attachment.cgi?id=23048
 > 
 > This patch fixes my problem.
 
Thanks for that Kurt.  I'll get this merged and on the way to
Linus & stable today.

	Dave

