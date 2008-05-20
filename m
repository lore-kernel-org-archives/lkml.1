Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYETIKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYETIKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbYETIKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:10:35 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48744 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758136AbYETIKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:10:30 -0400
X-Sasl-enc: XYQpQ/mugL0OIYTY5nTF3H62YyiOT6xBMVFvWhyOCLsJ 1211271028
Message-ID: <48328771.4030804@ladisch.de>
Date: Tue, 20 May 2008 10:10:25 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kallol Biswas <nucleodyne@gmail.com>
CC: Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: HDMI Audio Support in ALSA
References: <438397970805190904i2656337dh26a3257fe52aa29d@mail.gmail.com>	 <75b66ecd0805190916r7ce21667laf19783dfa47cdd7@mail.gmail.com> <438397970805190938t195d9a8ejfd5b0ca1409714ab@mail.gmail.com>
In-Reply-To: <438397970805190938t195d9a8ejfd5b0ca1409714ab@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please don't top-post)

Kallol Biswas wrote:
> Can ALSA handle HDMI audio frames? It does not look so.

Why do you think so?

> Do you need a pointer to HDMI audio spec (L-PCM, IEC 60958 IEC 61937 etc.)?

L-PCM is linear PCM, which is the sample format used by practically
_every_ sound card.  IEC 60958 is AES/EBU, which is essentially S/PDIF,
which uses linear PCM samples.  IEC 61937 specifies how to transport
compressed streams over S/PDIF, by pretending the data stream is a
sequence of linear PCM samples.

All of this is supported by ALSA.


Regards,
Clemens
