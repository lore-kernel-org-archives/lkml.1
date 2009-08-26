Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZHZMAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZHZMAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbZHZMAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:00:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47828 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZHZMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:00:05 -0400
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?=" <pasik@iki.fi>
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, hannes@cmpxchg.org,
       torvalds@linux-foundation.org
In-Reply-To: <20090826115415.GJ19938@edu.joroinen.fi>
References: <4A9407B1.6020400@nets.rwth-aachen.de>
	 <20090826115415.GJ19938@edu.joroinen.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 26 Aug 2009 15:00:05 +0300
Message-Id: <1251288005.31875.1.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 14:54 +0300, Pasi Kärkkäinen wrote:
> On Tue, Aug 25, 2009 at 05:48:01PM +0200, Arnd Hannemann wrote:
> > Hi,
> > 
> > current 2.6.31 fails to boot on our xen host (32bit pae).
> > Unfortunately it fails in a way that there is absolutely no output
> > on the console. Config is as 32bit guest.
> > 
> 
> Did you try "console=hvc0 earlyprintk=xen" kernel cmdline options? 

FYI, the bug is already fixed in -tip:

http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=commitdiff;h=d560bc61575efae43595cbcb56d0ba3b9450139c

