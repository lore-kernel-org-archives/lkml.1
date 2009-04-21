Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZDUOoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZDUOoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZDUOoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:44:00 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:33673 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZDUOn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:43:58 -0400
Date: Tue, 21 Apr 2009 10:35:57 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: "Luck, Tony" <tony.luck@intel.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, randy.dunlap_ocs10g@oracle.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next ia64 build problems in slqb
In-Reply-To: <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0904211034550.19969@qirst.com>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com> <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-716562517-337908754-1240324557=:19969"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---716562517-337908754-1240324557=:19969
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 21 Apr 2009, Pekka Enberg wrote:

> On Tue, Apr 21, 2009 at 1:08 AM, Luck, Tony <tony.luck@intel.com> wrote:
> > The ia64 "allnoconfig" build ends up with the (possibly dubious) combin=
ation
> > of .config options:
> >
> > =A0 =A0 =A0 =A0CONFIG_SMP=3Dn
> > =A0 =A0 =A0 =A0CONFIG_NUMA=3Dy
>
> Yeah, I don't think the combination makes much sense and x86 doesn't
> allow it. Can we fix that in ia64 Kconfig? That said, this seems to
> come up with every architecture except x86, so if someone is kind
> enough to send me a tested fix for slqb, I'll just go ahead and apply
> it.

Tony runs tests with this configuration. This is an established
configuration and has been historically supported.


---716562517-337908754-1240324557=:19969--
