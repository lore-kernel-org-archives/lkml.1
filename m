Return-Path: <linux-kernel-owner+w=401wt.eu-S1763540AbYBZUlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763540AbYBZUlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYBZUle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:41:34 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57379 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYBZUld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:41:33 -0500
Date: Tue, 26 Feb 2008 13:03:50 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86: vSMP selection in config
In-reply-to: <20080226200512.GA32685@uranus.ravnborg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>
Message-id: <200802261303.51777.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
 <200802242243.49576.yinghai.lu@sun.com>
 <20080226200512.GA32685@uranus.ravnborg.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 12:05:12 pm Sam Ravnborg wrote:
> On Sun, Feb 24, 2008 at 10:43:49PM -0800, Yinghai Lu wrote:
> > 
> > find out vSMP setting is going away in config after make oldconfig
> > 
> > vSMP need to PARAVIRT and PCI.
> > so move PARAVIRT out of if PARAVIRT_GUEST, and make vSMP select PCI instead of
> > depends on PCI
> > 
> > after patch vSMP could stick there.
> 
> I'm certain that we have hit a Kconfig bug / limitation here and
> the patch below is just a workaround for that issue.
> 
> I tracked it down to a minimal case and hope Roman can provide
> either an explanation or a fix.
> 
> IMO VSMP can wait until this is resolved properly and we should not
> apply this patch.

also Kconfig seems ignore
if PARAVIRT_GUEST

endif

and 
to use config PARAVIRT in that if block.

YH
