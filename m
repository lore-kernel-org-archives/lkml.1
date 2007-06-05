Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbXFEBAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbXFEBAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 21:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbXFEBAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 21:00:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:44838 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372AbXFEBAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 21:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gsgOe+tFLgPHxBzLNYNkPqLe4FUo+Zc+7elEsON24kzQEnv94B7cde/5VPRoXxhin+1hSSBLDVN/7WMqAAt8a+ncUl6WBZLDIiQZi86aNTwv0QOqrZofSQ4KouFTBM046RQuy1BmO2R3xNGBBDTZbhPuosGu0IB233lSH0yFdlw=
Message-ID: <86802c440706041759q1b2d528ex24b3de514d09d9ef@mail.gmail.com>
Date: Mon, 4 Jun 2007 17:59:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <m1myzfwi0x.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
	 <200706011407.51779.jbarnes@virtuousgeek.org>
	 <20070601211943.GO7217@one.firstfloor.org>
	 <200706011441.57149.jbarnes@virtuousgeek.org>
	 <m1r6orwptz.fsf@ebiederm.dsl.xmission.com>
	 <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
	 <20070604201823.7b7cb328@the-village.bc.nu>
	 <m1myzfwi0x.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Exactly, and given that this is a fairly easy thing to do, and that
> occasionally we see systems where this happens (even if their BIOS is
> later fixed).  It is likely worth it for someone to write up the patch
> and that compare MTRRs with available memory, and to complain and
> reserve all memory that MTRRs claim is not write-back.
>
that is good.
Sometime BIOS can not even keep mtrr to the identical between
different CPU in SMP system.

Or reset mtrr according to e820 table.

YH
