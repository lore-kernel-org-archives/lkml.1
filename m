Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbYFPHed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbYFPHed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYFPHeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:34:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:7767 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYFPHeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XlcwLxBvOJ9zJlq3MCq8Yj4tKubeEgZpHW49M+FUlJIbP7z6Nv0fC+fxdu8SgUED0j
         6J/KFe18YhRDm9HB/eXl76tJ6VqkJjFEKDnH4KrdJFdodiE3EW6v1xb/TqIW7B0r87Ms
         JSZoCUvQ/9JHOZOvuYBj1rnRaeoZHArAkxMXM=
Message-ID: <86802c440806160034r343f9570ma0141df8af9360d7@mail.gmail.com>
Date: Mon, 16 Jun 2008 00:34:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap memory ranges
Cc: mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
       andi@firstfloor.org, akpm@linux-foundation.org
In-Reply-To: <20080616023200.16eafc18.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	 <86802c440806152354i24a1ec5ap316dacec0981d05@mail.gmail.com>
	 <20080616023200.16eafc18.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 12:32 AM, Paul Jackson <pj@sgi.com> wrote:
> Yinghai wrote:
>> how about patial overlapping?
>
> I do not understand what you ask.
>
> I suppose your question is a minor typo of:
>
>> how about partial overlapping?
>
> ... however I don't understand that either - sorry.

EFI memmap and ebda is partial overlapping?

you may expand range_in_ebda_area(), and let it handle overlapping...

YH
