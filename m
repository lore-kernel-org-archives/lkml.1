Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYDXNoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYDXNoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbYDXNnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:43:53 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:49912 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYDXNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:43:52 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
From: Andi Kleen <andi@firstfloor.org>
References: <200804232055.13102.mb@bu3sch.de>
Date: Thu, 24 Apr 2008 15:43:50 +0200
In-Reply-To: <200804232055.13102.mb@bu3sch.de> (Michael Buesch's message of "Wed, 23 Apr 2008 20:55:12 +0200")
Message-ID: <87mynjgyg9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2008 13:37:00.0657 (UTC) FILETIME=[4624E610:01C8A610]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch <mb@bu3sch.de> writes:

> This untested patch is supposed to fix DMAing on some VIA boards.
> Currently the DMA subsystem returns an error, if the driver does
> tell that it supports a 64bit DMA mask. So the driver probing
> would fail in that case. 

The driver is broken then. It is supposed to retry with a small
mask on an error. Please fix the driver.

-Andi
