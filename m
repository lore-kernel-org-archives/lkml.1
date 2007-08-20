Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbXHTQsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbXHTQsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760691AbXHTQsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:48:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:44741 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760903AbXHTQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:48:29 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <20070808142059.GF30805@atjola.homenet>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Aug 2007 09:44:56 -0700
Message-Id: <1187628296.7732.14.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 16:20 +0200, Björn Steinbrink wrote:
> On 2007.08.07 17:06:49 -0700, Daniel Walker wrote:
> > 
> > This patch below hangs my system on boot if I set nmi_watchdog=2 . It
> > shows the NMI as stuck then the system hangs .. nmi_watchdog=1 works
> > fine, and the system boots without any watchdog options ..
> > 
> > The machine is an Intel allagash development board, and it has two dual
> > core Pentium-M cpus. I attached the .config I used.

Could we put this on the known regressions list? It was added in 2.6.21,
and still exists in lastest git (as of 15 min. ago) ..

Daniel

