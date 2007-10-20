Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbXJTMa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbXJTMa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 08:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbXJTMau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 08:30:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:18784 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbXJTMat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=rIGfs7l3s/zfLhl+4CZxnZaMEiKggYYwGVPyviVg03b327enaSr3A20VYDcAgsE8dIAKY0r4q1svCMwGCIq5A5rWnvbaDT47KoSV2Fp35HNb1y03Iw4IU2RQ+PQ/2JEul5QC3bzluRmTNh5dLDxDeOhi69+fO2jLEm+E4D0ksCM=
Date: Sat, 20 Oct 2007 14:39:10 -0700
To: Paul Mundt <lethal@linux-sh.org>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linuxsh <linuxsh-dev@lists.sourceforge.net>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH / HP6XX] : Add Timer values into HD64461.h
Message-Id: <20071020143910.24e4b4bf.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <20071019034937.GA8477@linux-sh.org>
References: <20071018213904.c0be3b03.Kristoffer.ericson@gmail.com>
	<20071019034937.GA8477@linux-sh.org>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 12:49:37 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Thu, Oct 18, 2007 at 09:39:04PM -0700, Kristoffer Ericson wrote:
> > This patch adds HD64461 Timer adresses & registers to the HD64461
> > header file (/include/asm-sh/hd64461.h).  The timers (TMU0 & TMU1) can
> > hold 16bit values and auto loads the counter constant when it reaches
> > zero. Upon reaching zero it generates an interrupt.
> > 
> > Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> > 
> There's nothing that uses these, so why are you adding them? If you plan
> on hooking these up in the hd64461 or TMU code, submit these definitions
> along with the code that uses them.
We plan on use these timer interrupts to drive the alsa sounddriver. But you are quite correct, I'll resubmit these
as soon as the alsa driver is finished.

-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
