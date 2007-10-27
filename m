Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbXJ0LdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbXJ0LdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 07:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXJ0Lc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 07:32:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43536 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbXJ0Lc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 07:32:56 -0400
Date: Sat, 27 Oct 2007 13:32:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Markus Elfring <Markus.Elfring@web.de>
cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: Check handling of kernel build output directory
In-Reply-To: <fftdpt$iqf$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0710271332440.30465@fbirervta.pbzchgretzou.qr>
References: <fft89p$rko$1@ger.gmane.org> <19f34abd0710261036m65fd0d3bjace68c860a29023b@mail.gmail.com>
 <fftcal$dim$1@ger.gmane.org> <fftdpt$iqf$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 26 2007 21:05, Markus Elfring wrote:
>>> Aren't you supposed to use O= as described by "make help"?
>> 
>> I expect that both ways should work. I find it easier to use the environment variable
>> "KBUILD_OUTPUT" because the command line parameter does not need to be repeated on each
>> make invocation.
>
>A wording correction:
>I expect that both ways should work. I find it easier to use the environment variable
>"KBUILD_OUTPUT" because it does not need to be repeated on each make invocation like it
>must happen with the command line parameter "O=".

So why not just...
	export O=/foo/bar
