Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYCVVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYCVVVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYCVVVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:21:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:8917 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbYCVVVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D/WzuFc0kiq0ASq24aYxAyrP72UJXHaPe76+UhTB4yslgaIVLN7GaVjxScQHb3mM5c7vieBQ7rTjy1ZJIQZUYSpux8stTH3w7d8pgAA1MomAwB6R/5KeatPRck3oyuyw4vX5opbHhFw2NESjuaO8UuW2RWKdQCvl2hFjTTntiJ4=
Message-ID: <86802c440803221421s77c710bev91105d4b45baa8a6@mail.gmail.com>
Date: Sat, 22 Mar 2008 14:21:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Cc: yhlu.kernel.send@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080322134814.7258ff0c@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803202358.33722.yhlu.kernel@gmail.com>
	 <20080322134814.7258ff0c@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 1:48 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Thu, 20 Mar 2008 23:58:33 -0700
>
> Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  >
>
> > do simple memtest after init_memory_mapping
>  >
>  > use find_e820_area_size to find all ram range that is not reserved.
>
>  be careful, there's some special memory that e820 right now says is not reserved,
>  but still has bios data (the first 4Kb of memory come to mind)
only test ranges that have E820_RAM and exclude range that is early_reserved...
so it is safe.

YH
