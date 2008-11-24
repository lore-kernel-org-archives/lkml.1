Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYKXCto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYKXCto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 21:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYKXCtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 21:49:33 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56472 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYKXCtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 21:49:32 -0500
Date: Mon, 24 Nov 2008 02:49:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: no SD card reader
Message-ID: <20081124024928.GA6216@srcf.ucam.org>
References: <20081014025453.617f2ef8@werewolf.home> <20081014174536.1353d17e@mjolnir.drzeus.cx> <20081014232759.08f5d212@werewolf.home> <20081123213921.667ecb93@mjolnir.drzeus.cx> <4929D803.80708@tuffmail.co.uk> <20081123233007.GA3959@srcf.ucam.org> <20081124012541.616c9f84@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081124012541.616c9f84@werewolf.home>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 01:25:41AM +0100, J.A. Magallón wrote:
> Thanks for the info. Just a couple questions:
> 
> - Is there any pointer to a patch that can be applied to current stable
>  (2.6.27.6) ?

http://lkml.org/lkml/diff/2008/11/13/420/1 ought to, with either luck or 
a little massaging.

> - I have tried to load acpiphp on the aspire and it says it has
>   'No such device'. Does the patch include something to make it load and
>   recognize the Aspire's PCI ? Is this module independent or do I need
>   also pciephp or shpchp ?

That patch should be all you need.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
