Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZJ2DPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZJ2DPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 23:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZJ2DPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 23:15:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:51864 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZJ2DPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 23:15:36 -0400
Subject: Re: [PATCH 3/6 v5] Memory probe/release files
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AE8AFDD.6030504@austin.ibm.com>
References: <4AE8ADCF.6090104@austin.ibm.com>
	 <4AE8AFDD.6030504@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 14:13:33 +1100
Message-ID: <1256786013.26770.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 15:55 -0500, Nathan Fontenot wrote:
> This patch creates the release sysfs file for memory and updates the
> exisiting probe file so both make arch-specific callouts to handle removing
> and adding memory to the system.  This also creates the powerpc specific stubs
> for handling the arch callouts.
> 
> The creation and use of these files are governed by the exisitng
> CONFIG_ARCH_MEMORY_PROBE and new CONFIG_ARCH_MEMORY_RELEASE config options.
> 
> Signed-off-by: Nathan Fontenot <nfont at austin.ibm.com>
> ---

Is there anybody on linux-mm who needs to Ack this patche ?

Cheers,
Ben.



