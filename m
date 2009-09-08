Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZIHTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZIHTGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZIHTGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:06:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:46314 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751870AbZIHTGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:06:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19uK4UDLBNu7zW7HACEY0sFFtU/Kgn+MNLYHUamhF
	91G/YnGrIm1R9P
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Mike Galbraith <efault@gmx.de>
To: Anirban Sinha <ani@anirban.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dario Faggioli <raistlin@linux.it>,
       Anirban Sinha <ASinha@zeugmasystems.com>
In-Reply-To: <217247FB-ED91-4A24-B698-71CEEFA58636@anirban.org>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net>
	 <DDFD17CC94A9BD49A82147DDF7D545C54DC48B@exchange.ZeugmaSystems.local>
	 <217247FB-ED91-4A24-B698-71CEEFA58636@anirban.org>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 21:06:28 +0200
Message-Id: <1252436788.6923.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 10:41 -0700, Anirban Sinha wrote:
> On 2009-09-08, at 10:32 AM, Anirban Sinha wrote:
> 

> > Dunno.  Fly or die little patchlet (toss).
> 
> So it would be nice to have a knob like this when CGROUPS is disabled  
> (it say 'say N  when unsure' :)). CPUSETS depends on CGROUPS.

Maybe.  Short term hack.  My current thoughts on the subject, after some
testing, is that the patchlet should just die, and pondering the larger
solution should happen.

	-Mike

