Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZCIJeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZCIJeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZCIJeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:34:06 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:63110 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZCIJeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:34:04 -0400
Date: Mon, 9 Mar 2009 10:33:54 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390@vger.kernel.org,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG,2.6.29-rc7,s390] System goes into endless loop during
	boot or logon
Message-ID: <20090309093354.GA4124@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Frans Pop <elendil@planet.nl>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080835.14032.elendil@planet.nl> <200903090253.34173.elendil@planet.nl> <1236587118.8389.20.camel@laptop> <200903091025.53284.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903091025.53284.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 10:25:51AM +0100, Frans Pop wrote:
> > Where? Do you have NMI watchdog output, or even sysrq-t?
> 
> I'm afraid I have no idea.
> 
> AFAICT s390 does not have an NMI watchdog. And I have no idea how I could 
> trigger a sysrq given that I can't login and only have a dumb console or 
> SSH session to work with anyway.
If SSH works,  try to trigger the sysrq function trough /proc/sysrq-trigger,
e.g.  echo l > /proc/sysrq-trigger

Regards
  Hendrik Brueckner

-- 
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

