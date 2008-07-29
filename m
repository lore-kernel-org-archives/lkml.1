Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYG2HIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYG2HIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYG2HIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:08:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYG2HI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:08:29 -0400
Message-ID: <488EC1DA.7000708@manoweb.com>
Date: Tue, 29 Jul 2008 00:08:10 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Iwo Mergler <iwo@call-direct.com.au>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: interrupt overhead on ARM architecture
References: <488E7F08.7060309@manoweb.com> <488EA477.7070101@call-direct.com.au>
In-Reply-To: <488EA477.7070101@call-direct.com.au>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19uImL3OdVpCphg4lU7ZPtAQvec0f65A19NEFx
 05KFdCTOs1uDs+aIule6dPDqx2VXil5rGTIS4pPrgs5qhddB/R
 XXpVieWyyfnfrP1aYC2eA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iwo Mergler wrote:

> In other words, you can't even measure the latency on a particular
> system and then assume it will stay anywhere near constant. Comparing
> different systems with the same processor core is hopeless.

Everything makes perfect sense. For this reason, I am willing to do some
tests on my own platform. How would you suggest to proceed? I would need
an extremely accurate way to measure time to begin with and then:

- read that time reference
- generate an interrupt by placing some data in a device or so
- reading again that time reference as first thing in the ISR
- save the result

- do the above in various scenarios, with different drivers enabled, CPU
load, etc etc

bye
Alessio

