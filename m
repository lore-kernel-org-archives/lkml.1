Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYCVVV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYCVVV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYCVVVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:21:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:10524 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbYCVVVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gir8JBHQ8KP4U6SDI8MmIr1S/r3jrSeKpfHwHufbrzFgfZJJ1TFudKpLSswcOhoC86j9qm47jpvw3XfxSnkeCKGq4if9GZ2GnOge6UucpIeqe8204Zn2Ws+fZctLeoQVuGCQdcMnMtqzqRUombRYPUBDMAhGOkxc43BUCnMktIU=
Message-ID: <86802c440803221421i544dc896qb63750237ffc50c4@mail.gmail.com>
Date: Sat, 22 Mar 2008 14:21:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Cc: "Arjan van de Ven" <arjan@infradead.org>, yhlu.kernel.send@gmail.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <47E57393.7060606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803202358.33722.yhlu.kernel@gmail.com>
	 <20080322134814.7258ff0c@laptopd505.fenrus.org>
	 <47E57393.7060606@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 2:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Arjan van de Ven wrote:
>  > On Thu, 20 Mar 2008 23:58:33 -0700
>  > Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>  >
>  >> do simple memtest after init_memory_mapping
>  >>
>  >> use find_e820_area_size to find all ram range that is not reserved.
>  >
>  > be careful, there's some special memory that e820 right now says is not reserved,
>  > but still has bios data (the first 4Kb of memory come to mind)
>  >
>
>  Is that true even after Yinghai's changes?  I have lost track of all the
>  patches...

find_e820_area_size should be safe.

YH
