Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbZGTRHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbZGTRHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZGTRHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:07:16 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33983 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZGTRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:07:15 -0400
Date: Mon, 20 Jul 2009 19:07:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, Tim Abbott <tabbott@ksplice.com>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
Message-ID: <20090720170713.GA6728@merkur.ravnborg.org>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu> <20090716203432.GB6096@merkur.ravnborg.org> <alpine.DEB.1.10.0907161636090.6798@vinegar-pot.mit.edu> <alpine.DEB.1.10.0907161841210.6798@vinegar-pot.mit.edu> <20090717221336.GA7336@merkur.ravnborg.org> <alpine.DEB.1.10.0907181236440.23110@vinegar-pot.mit.edu> <20090720163638.GB29422@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720163638.GB29422@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 01:36:38AM +0900, Paul Mundt wrote:
> On Mon, Jul 20, 2009 at 12:33:07PM -0400, Tim Abbott wrote:
> > On Sat, 18 Jul 2009, Sam Ravnborg wrote:
> > > I do not expect Tejun's work to be included until next merge window.
> > 
> > Yes, but I expect the "sh" patch presumably to go in at the next merge 
> > window as well.  Since in this case the conflict was both patches making 
> > similar changes where Tejun's was more extensive, I figured I might as 
> > well save someone from having to resolve this useless merge conflict 
> > during the next merge window.
> > 
> Correct, the sh change is queued for the next merge window. For 2.6.31 we
> are not using the generic macros in the script, so the breakage is
> immaterial there. There will be a bit of an ordering issue for the merge
> window with regards to the kbuild fixes, but as long as the revised
> macros show up at some point then I can merge after that. If kbuild-fixes
> merges before the merge window then of course the ordering issue goes
> away.

I plan to send Linus a pull request later today for the kbuild-fixes stuff.
I need to review the cahnges a last time.

	Sam
