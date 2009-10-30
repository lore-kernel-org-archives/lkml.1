Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZJ3Mj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZJ3Mj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 08:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZJ3Mj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 08:39:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46017 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877AbZJ3Mj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 08:39:58 -0400
Subject: Re: [PATCH][RE-SUBMIT] Default setting of the ARM_UNWIND option
From: Catalin Marinas <catalin.marinas@arm.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
       akpm@linux-foundation.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4AEAC9D8.9000304@evidence.eu.com>
References: <4AD73DA4.4050006@evidence.eu.com>
	 <1255620333.10164.77.camel@pc1117.cambridge.arm.com>
	 <4AE55D83.7080608@evidence.eu.com>
	 <1256555452.5282.21.camel@pc1117.cambridge.arm.com>
	 <4AE82D17.6040900@evidence.eu.com>
	 <1256741902.27121.29.camel@pc1117.cambridge.arm.com>
	 <4AEAC9D8.9000304@evidence.eu.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 30 Oct 2009 12:39:16 +0000
Message-Id: <1256906356.27014.22.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2009 12:39:17.0575 (UTC) FILETIME=[FED60570:01CA595D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-30 at 12:11 +0100, Claudio Scordino wrote:
> From: Claudio Scordino <claudio@evidence.eu.com>
> Date: Fri, 30 Oct 2009 11:46:00 +0100
> Subject: [PATCH 1/1] ARM unwind is known to compile only with EABI and
> not-buggy compilers.
> 
> ARM unwind is known to compile only with EABI and not-buggy compilers.
> The problem is not the unwinding information but the
> -fno-frame-pointer option added as a result of !CONFIG_FRAME_POINTER.
> Now we check the compiler and raise a #warning in case of wrong
> compiler.
> 
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>

Unless others have objections, here's my ack:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin

