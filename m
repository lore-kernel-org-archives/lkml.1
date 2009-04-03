Return-Path: <linux-kernel-owner+w=401wt.eu-S936855AbZDCVsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936855AbZDCVsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbZDCVsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:48:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:9414 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805AbZDCVsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SlvubJG9byN10xvlJq7MsA26RcrV62hWqityO6FiI8xa+FMMrB77m+6FnARpLYgu63
         885UsdaF3uyFq8gLU/l0HT0PWWVfHRv+pXXqLXgCMSw/T+bfIX1MER9yoczuFPmTzufK
         OS+XjMum48GunDbqKVdnbkggLFNjxPMei+qGQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
	 <87vdpljuqi.fsf@basil.nowhere.org>
	 <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com>
Date: Fri, 3 Apr 2009 14:48:31 -0700
Message-ID: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com>
Subject: Re: Off topic: Numactl "distance" wrong
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 2:43 PM, David Rientjes <rientjes@google.com> wrote:
>
> Yinghai, can you elaborate on exactly what type of interface you can
> imagine for modifying the distance for nodes through sysfs?  It seems like
> you'd have to report the entire physical topology in one write, for which
> we currently don't have an interface for beyond pxms, instead of per-node
> distances to remote nodes.

acpi_numa_slit_init() in srat_64.c will have one copy (called
acpi_slit) of SLIT, if there is SLIT from ACPI.

so if numa is enabled, could expose that acpi_slit via sysfs for the
user to update it.

YH
