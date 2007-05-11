Return-Path: <linux-kernel-owner+w=401wt.eu-S1762684AbXEKA4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762684AbXEKA4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbXEKA4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:56:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbXEKA4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:56:34 -0400
Message-ID: <4643BF1E.50200@zytor.com>
Date: Thu, 10 May 2007 17:55:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Martin Mares <mj@ucw.cz>
CC: Alexander van Heukelum <heukelum@fastmail.fm>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar.ms.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com> <1178806235.18785.1189115515@webmail.messagingengine.com> <46435F8A.1040203@zytor.com> <mj+md-20070510.183659.21639.nikam@ucw.cz>
In-Reply-To: <mj+md-20070510.183659.21639.nikam@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Mares wrote:
> Hello!
> 
>> As far as I could tell, "scan" simply caused the nonstandard video
>> driver scan modules (unsafe probes) to be invoked.  Since those modules
>> are no longer present, there appeared to be no need for them.  The VGA
>> and VESA probes are safe.
> 
> "scan" is still useful, because it is able to find BIOS video modes with
> non-standard numbers (they are still sometimes found on recent cards).

Well, I don't have a card which does anything like that, but I did just
implement the "scan" functionality and pushed it out.  If anyone cares
about that functionality it would be good if they could test it out and
report if it works.

	-hpa
