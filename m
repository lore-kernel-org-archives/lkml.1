Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZGTQhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZGTQhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZGTQhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:37:17 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44262 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZGTQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:37:16 -0400
Date: Tue, 21 Jul 2009 01:36:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
Message-ID: <20090720163638.GB29422@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
	linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Anders Kaseorg <andersk@ksplice.com>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu> <20090716203432.GB6096@merkur.ravnborg.org> <alpine.DEB.1.10.0907161636090.6798@vinegar-pot.mit.edu> <alpine.DEB.1.10.0907161841210.6798@vinegar-pot.mit.edu> <20090717221336.GA7336@merkur.ravnborg.org> <alpine.DEB.1.10.0907181236440.23110@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907181236440.23110@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 12:33:07PM -0400, Tim Abbott wrote:
> On Sat, 18 Jul 2009, Sam Ravnborg wrote:
> > I do not expect Tejun's work to be included until next merge window.
> 
> Yes, but I expect the "sh" patch presumably to go in at the next merge 
> window as well.  Since in this case the conflict was both patches making 
> similar changes where Tejun's was more extensive, I figured I might as 
> well save someone from having to resolve this useless merge conflict 
> during the next merge window.
> 
Correct, the sh change is queued for the next merge window. For 2.6.31 we
are not using the generic macros in the script, so the breakage is
immaterial there. There will be a bit of an ordering issue for the merge
window with regards to the kbuild fixes, but as long as the revised
macros show up at some point then I can merge after that. If kbuild-fixes
merges before the merge window then of course the ordering issue goes
away.
