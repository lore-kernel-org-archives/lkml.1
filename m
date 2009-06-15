Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbZFOQ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbZFOQ5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZFOQ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:57:36 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:60548 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbZFOQ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:57:35 -0400
From: Frans Pop <elendil@planet.nl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: PC speaker beeps in 2.6.30?
Date: Mon, 15 Jun 2009 18:57:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4A365DA6.8000102@msgid.tls.msk.ru>
In-reply-To: <4A365DA6.8000102@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151857.36576.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jun 2009 16:57:37.0031 (UTC) FILETIME=[62A39170:01C9EDDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Anyone know what happened with PC speaker in 2.6.30?
> Basically, it does not work anymore here, with the
> config which is very similar to the one used for
> previous 2.6.29 kernel (where PC speaker worked).
> At least I don't see any relevant differences and
> the (seemengly) relevant symbols -- which are
> INPUT_PCSPKR and PCSPKR_PLATFORM -- are both set
> to 'y' for both 2.6.29 and 2.6.30.

For me the system beep has been replaced by a beep in ALSA with .30.

Do you have soundcard that uses HDA? Is CONFIG_SND_HDA_INPUT_BEEP set?
Does alsamixer show a "beep" control? Is that not muted and does it have 
volume set?

Cheers,
FJP
