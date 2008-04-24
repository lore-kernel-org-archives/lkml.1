Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYDXOGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYDXOGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYDXOG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:06:29 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:51742 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYDXOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:06:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
Date: Thu, 24 Apr 2008 16:06:00 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com
References: <200804232055.13102.mb@bu3sch.de> <87mynjgyg9.fsf@basil.nowhere.org>
In-Reply-To: <87mynjgyg9.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241606.00883.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2008 15:43:50 Andi Kleen wrote:
> Michael Buesch <mb@bu3sch.de> writes:
> 
> > This untested patch is supposed to fix DMAing on some VIA boards.
> > Currently the DMA subsystem returns an error, if the driver does
> > tell that it supports a 64bit DMA mask. So the driver probing
> > would fail in that case. 
> 
> The driver is broken then. It is supposed to retry with a small
> mask on an error. Please fix the driver.

I already added a workaround to the driver.
Why do we need to workaround this in _every_ driver? (Note that _every_
driver supporting a 64bit mask is affected). Why not fix it in the DMA layer?

-- 
Greetings Michael.
