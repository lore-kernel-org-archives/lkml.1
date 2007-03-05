Return-Path: <linux-kernel-owner+w=401wt.eu-S933492AbXCEOqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbXCEOqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933493AbXCEOqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:46:34 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22096 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933492AbXCEOqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:46:34 -0500
Message-ID: <45EC2D43.8010108@tls.msk.ru>
Date: Mon, 05 Mar 2007 17:46:27 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Thunderbird 1.5.0.5 (X11/20060813)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: discuss@x86-64.org, Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86_64: add reporting of SVM flags to /proc/cpuinfo
References: <20070305143601.GF30318@amd.com> <20070305143911.GG30318@amd.com>
In-Reply-To: <20070305143911.GG30318@amd.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> +++ b/arch/x86_64/kernel/setup.c
> +	static char *x86_svm_flags[] = {
> +		"npt",
> +		"lbrv",
> +		"svmlock",
> +	};

A nitpick:

static const char *const x86_svm_flags[] = ... ?

/mjt
