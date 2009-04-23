Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZDWF4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZDWF4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 01:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZDWF4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 01:56:03 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32897 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZDWF4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 01:56:01 -0400
Date: Thu, 23 Apr 2009 14:50:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: "Luck, Tony" <tony.luck@intel.com>, Christoph Lameter <cl@linux.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "iwamatsu.nobuhiro@renesas.com" <iwamatsu.nobuhiro@renesas.com>
Subject: Re: linux-next ia64 build problems in slqb
Message-ID: <20090423055049.GA21733@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	"Luck, Tony" <tony.luck@intel.com>,
	Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@suse.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"iwamatsu.nobuhiro@renesas.com" <iwamatsu.nobuhiro@renesas.com>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com> <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com> <alpine.DEB.1.10.0904211034550.19969@qirst.com> <84144f020904211125v68b98df4ke1c04bc29df65fda@mail.gmail.com> <57C9024A16AD2D4C97DC78E552063EA39EC57748@orsmsx505.amr.corp.intel.com> <84144f020904211207q736bfc44n4cd622536cd0a67@mail.gmail.com> <57C9024A16AD2D4C97DC78E552063EA39EC57AB7@orsmsx505.amr.corp.intel.com> <Pine.LNX.4.64.0904220953040.20610@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904220953040.20610@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 10:02:06AM +0300, Pekka J Enberg wrote:
> On Tue, 21 Apr 2009, Luck, Tony wrote:
> > > One minor nit: the patch should define an empty static inline of
> > > claim_remote_free_list() for the !SMP case. I can fix it at my end
> > > before merging, though, if necessary.
> > 
> > Agreed.  It would be better to have an empty static inline than
> > adding the noisy #ifdef SMP around every call to
> > claim_remote_free_list() ... in fact some such #ifdef can be
> > removed.
> > 
> > You could tag such a modified patch (attached) as:
> > 
> > Acked-by: Tony Luck <tony.luck@intel.com>
> 
> Thanks for the help! I went and merged the following patch and I hope I 
> got all the patch attributions right. Paul, does this work for you as well?
> 
Yup, works fine for me, thanks for taking care of this.

Acked-by: Paul Mundt <lethal@linux-sh.org>
