Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZBAB0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZBAB0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZBABZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:25:57 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60821 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZBABZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:25:57 -0500
X-Sasl-enc: MOh19ATa1o4NAkoVTfJrWvTBB/KCGp85EPx471sl4x1R 1233451555
Date: Sat, 31 Jan 2009 23:25:53 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: Tim Small <tim@buttersideup.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       ncunningham-lkml@crca.org.au, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Chris Friesen <cfriesen@nortel.com>,
       Doug Thompson <norsk5@yahoo.com>, bluesmoke-devel@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: marching through all physical memory in software
Message-ID: <20090201012553.GB22841@khazad-dum.debian.net>
References: <715599.77204.qm@web50111.mail.re2.yahoo.com> <m1wscc7fop.fsf@fess.ebiederm.org> <49836114.1090209@buttersideup.com> <m1iqnw1676.fsf@fess.ebiederm.org> <4984489C.8020309@buttersideup.com> <20090131134327.GB28763@khazad-dum.debian.net> <20090131212754.GA15243@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090131212754.GA15243@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009, Pavel Machek wrote:
> > You can also implement software-based ECC using a background scrubber
> > and setting aside pages to store the ECC information.  Now, THAT is
> > probably not worth bothering with due to the performance impact, but
> > who knows...
> 
> Actually, that would be quite cool. a) I suspect memory in  my zaurus
> bitrots and b) bitroting memory over s2ram is apprently quite common.

Well, software-based ECC for s2ram (calculate right before s2ram,
check-and-fix right after waking up) is certainly doable and a LOT
easier than my crazy idea of sofware-based generic ECC (which requires
some sort of trick to detect pages that were written to, so that you
can update their ECC information)...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
