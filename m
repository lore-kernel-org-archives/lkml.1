Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZJ2D2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZJ2D2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 23:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbZJ2D2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 23:28:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:53923 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbZJ2D2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 23:28:07 -0400
Subject: Re: [PATCH 6/6 v5] CPU DLPAR Handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AE8B0B1.4020102@austin.ibm.com>
References: <4AE8ADCF.6090104@austin.ibm.com>
	 <4AE8B0B1.4020102@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 14:26:03 +1100
Message-ID: <1256786763.26770.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 15:59 -0500, Nathan Fontenot wrote:

> +#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
> +static ssize_t cpu_probe(const char *buf, size_t count)

dlpar_cpu_probe() pls

> +static ssize_t cpu_release(const char *buf, size_t count)
> +{

Ditto.

Or else in system.map, backtraces, etc... it's hard to figure out off
hand where it's dying :-)

Cheers,
Ben.


