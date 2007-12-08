Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbXLHRn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbXLHRn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXLHRnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:43:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:20523 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbXLHRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tX/hilGECwiSSZZQHXQ+zWwJoI3x/UivnoIdD0rRnSztFiFOFMMioQnrlwwV/rOVgBbx2nQ6bBUWXdHkLKSrDzA6n+DpzBMcpki+54uSF0qHgRZ0pOLOvVKt2aLz9auu7CEAL2X9qYn95lQUGF8ds36S/+FSvcU9hPp+7sW/Bgo=
Message-ID: <475AD7D0.8040905@gmail.com>
Date: Sat, 08 Dec 2007 18:43:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu>
In-Reply-To: <20071208152447.GA30270@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2007 04:24 PM, Ingo Molnar wrote:
> i'm wondering why it had no effect now - the new code is in essence a 
> NOP over what we had.

Maybe a dumb question. Why those changes in process_32.c in the patch and not in
process_64.c?
