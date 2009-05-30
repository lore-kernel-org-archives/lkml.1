Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZE3K0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZE3K0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZE3K0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:26:25 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:54724 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZE3K0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:26:24 -0400
Message-ID: <4A2109C7.5080009@f2s.com>
Date: Sat, 30 May 2009 11:26:15 +0100
From: Ian molton <spyro@f2s.com>
Reply-To: ian@mnementh.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 2/5] mmc: tmio_mmc: add bus_shift support
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com> <1243279681-4233-3-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1243279681-4233-3-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ian Molton <ian@mnementh.co.uk>

Works fine on the e-series machines, however checkpatch has a few 
warnings about overlength lines. I dont think they are a problem, but 
its not my call - Pierre?

Philipp Zabel wrote:
> Some ASIC3 devices in the wild are connected with the address bus shifted
> by one line, so that its 16-bit registers appear 32-bit aligned in host
> memory space.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Pierre Ossman <pierre@ossman.eu>
> Cc: Ian Molton <spyro@f2s.com>
> ---
>  drivers/mmc/host/tmio_mmc.c |  127 +++++++++++++++++++------------------------
>  drivers/mmc/host/tmio_mmc.h |   72 +++++++++++++++++++++---
>  2 files changed, 118 insertions(+), 81 deletions(-)
