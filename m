Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbZE3KhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbZE3KhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZE3Kg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:36:56 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:56418 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbZE3Kg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:36:56 -0400
Message-ID: <4A210C3F.1070408@f2s.com>
Date: Sat, 30 May 2009 11:36:47 +0100
From: Ian molton <spyro@f2s.com>
Reply-To: ian@mnementh.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: pHilipp Zabel <philipp.zabel@gmail.com>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 2/5] mmc: tmio_mmc: add bus_shift support
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>	 <1243279681-4233-3-git-send-email-philipp.zabel@gmail.com> <74d0deb30905261316hd100bbdr96e5e544eed94c2e@mail.gmail.com>
In-Reply-To: <74d0deb30905261316hd100bbdr96e5e544eed94c2e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pHilipp Zabel wrote:
> On Mon, May 25, 2009 at 9:27 PM, Philipp Zabel <philipp.zabel@gmail.com> wrote:
>> Some ASIC3 devices in the wild are connected with the address bus shifted
>> by one line, so that its 16-bit registers appear 32-bit aligned in host
>> memory space.
> 
> This patch has to be amended:

I have to assume that this works - I have no asic3 hardware, and bus 
shift is zero on TMIO hardware, so this didnt cause issues.

This modification acked too.
