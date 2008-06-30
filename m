Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbYF3NWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbYF3NWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763047AbYF3NVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:21:43 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:53853 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbYF3NVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:21:42 -0400
To: Barbara Picci <barbara.picci@sardi.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help with Hardening Linux
From: Andi Kleen <andi@firstfloor.org>
References: <p0624081dc48e6036b8f4@[192.168.168.51]>
Date: Mon, 30 Jun 2008 15:21:39 +0200
In-Reply-To: <p0624081dc48e6036b8f4@[192.168.168.51]> (Barbara Picci's message of "Mon, 30 Jun 2008 12:04:42 +0200")
Message-ID: <8763rrukgs.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jun 2008 13:14:19.0120 (UTC) FILETIME=[34481700:01C8DAB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Barbara Picci <barbara.picci@sardi.it> writes:
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY=y
> # CONFIG_SECURITY_NETWORK is not set
> CONFIG_SECURITY_CAPABILITIES=y
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> # CONFIG_SECURITY_ROOTPLUG is not set
> CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
>
> I try to install lcap_0.0.6-3.1_i386.deb from packages.debian.org but,
> if I louch lcap, instead of the list of capabilities, I've:

The capabilities interface changed to require a later input data type
for more capabilities.

You probably need at least to recompile that program with uptodate
kernel headers.

Yes it bit lots of other people too. There's no good workaround.

-Andi
