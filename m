Return-Path: <linux-kernel-owner+w=401wt.eu-S933209AbYA2SI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbYA2SI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764272AbYA2SIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:08:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41204 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbYA2SIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:08:32 -0500
Message-ID: <479F6AD2.8050908@zytor.com>
Date: Tue, 29 Jan 2008 10:05:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>	 <479E5D22.1070109@goop.org> <1201599251.5301.26.camel@localhost.localdomain> <479F6845.1070902@goop.org>
In-Reply-To: <479F6845.1070902@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I solved that with some linker magic.  One of the things I did was get 
> rid of tools/build and did everything in the linker.  And I worked out a 
> trick where you can get the setup code to refer to vmlinux's symbols 
> without actually linking it in (no, wait, was that to solve something 
> else?).

It's also easy enough to either use objdump -h or nm to extract info 
from vmlinux; or for some of the simpler stuff, just parse the ELF 
directly (perhaps using libelf).

There is also the -R option to ld, which imports symbols from one 
executable into another.

	-hpa
