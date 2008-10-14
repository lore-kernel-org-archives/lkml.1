Return-Path: <linux-kernel-owner+w=401wt.eu-S1751272AbYJNNP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbYJNNP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYJNNPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:15:18 -0400
Received: from ironport2-out.pppoe.ca ([206.248.154.182]:34705 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYJNNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:15:17 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 09:15:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACI29EhMCpQ6/2dsb2JhbACBcr0RgWyBCA
X-IronPort-AV: E=Sophos;i="4.33,409,1220241600"; 
   d="scan'208";a="28367075"
From: Stefan Monnier <monnier@iro.umontreal.ca>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <jwvk5cbtjoq.fsf-monnier+inbox@gnu.org>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org>
	<20081014111800.GA32413@logfs.org>
Date: Tue, 14 Oct 2008 09:05:33 -0400
In-Reply-To: <20081014111800.GA32413@logfs.org> (=?iso-8859-1?Q?=22J=F6rn?=
 Engel"'s message of
	"Tue, 14 Oct 2008 13:18:00 +0200")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Or is there some hope for SSDs to provide access to the MTD layer in the
>> not too distant future?
> I've talked to manufacturers and not seen any enthusiasm for that idea.
> Most actually have some undocumented commands for raw access - for
> testing and QA.  They simply see no benefit in exposing these to the
> public.

Maybe if we could get our hands on such commands for a few such devices
and publicize a comparison between UBIFS and ext2 on it, we might get
some traction (assuming the comparison shows a significant benefit,
obviously)?

> And it is trivial to brick a device with such commands - in the
> sense that the FTL no longer works.

But that just requires an additional "format" command, right?
Actually, they could even force the use of format not only before the
use of FTL, but also before the use of the MTD layer, so they could
completely hide the underlying FTL metadata from reverse
engineering efforts (since they seem to care so much about their stupid
secrecy).


        Stefan
