Return-Path: <linux-kernel-owner+w=401wt.eu-S1751184AbZG1XR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbZG1XR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZG1XR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:17:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17161 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZG1XR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:17:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=H/IlthK+Mtutc+fq0AEFbIAyNcAQmm5uoKwRnbRxUpcU67GGU5nvH3jJOW/Gv3n4S
	pNba9aXCDF1uKUfUeqVJQ==
MIME-Version: 1.0
In-Reply-To: <4A68082C.8010604@cn.fujitsu.com>
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
	 <20090722195029.7481.94700.stgit@menage.mtv.corp.google.com>
	 <4A68013A.2020302@cn.fujitsu.com>
	 <6599ad830907222327s31340956y9783db39d076520f@mail.gmail.com>
	 <4A68082C.8010604@cn.fujitsu.com>
Date: Tue, 28 Jul 2009 16:17:51 -0700
Message-ID: <6599ad830907281617i4c03ee52u93e7eb69275379e9@mail.gmail.com>
Subject: Re: [PATCH 1/4] Support named cgroups hierarchies
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:50 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> Because it's not needed for the entire scope of the function. Keeping
>> its scope as small as possible makes it clearer what it's being used
>> for.
>>
>
> If we had been doing this, we'll see many:
>
>        (no if, while, for)
>        {
>                ...
>        }
>
> in kernel code, but I don't remember I ever saw this style.
>

Documentation/CodingStyle is silent on this subject. But OK, I've
moved new_root back to the top level. I think that it's a net loss to
readability though.

Paul
