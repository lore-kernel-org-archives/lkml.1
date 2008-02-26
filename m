Return-Path: <linux-kernel-owner+w=401wt.eu-S1765894AbYBZXQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765894AbYBZXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762356AbYBZXQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:16:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:39043 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbYBZXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CvJa4bPf4NPLwg31EsY4UR1eLmP4GUM0WVFYgm9/3/bEs5QFLR+gXVn1hWdwYKaKqTMMErMKTUwpWHbrNDoe0i8+CTEtZ2P4QIYzMHJZ+iXsBcYIJm7zl1u4YLu5JtVFdRNuw2Yl4WWRzoc+0W4pdOo7tXDgum3rONommPWlvBg=
Message-ID: <86802c440802261516n1ca8ef6eh5e6abdd0c3f959dd@mail.gmail.com>
Date: Tue, 26 Feb 2008 15:16:16 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran Thirumalai" <kiran@scalemp.com>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
In-Reply-To: <20080226212418.GJ5914@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080225190819.GE3143@localdomain>
	 <20080226033945.GJ3143@localdomain>
	 <20080226034625.GE21577@one.firstfloor.org>
	 <20080226040541.GK3143@localdomain>
	 <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com>
	 <20080226184235.GA5914@localdomain>
	 <86802c440802261100j322ee6a6yef9108dc175de459@mail.gmail.com>
	 <20080226203235.GH5914@localdomain>
	 <86802c440802261310y176cdfel38843e264bc71f82@mail.gmail.com>
	 <20080226212418.GJ5914@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 1:24 PM, Ravikiran Thirumalai <kiran@scalemp.com> wrote:
>
> On Tue, Feb 26, 2008 at 01:10:57PM -0800, Yinghai Lu wrote:
>  >On Tue, Feb 26, 2008 at 12:32 PM, Ravikiran Thirumalai
>  ><kiran@scalemp.com> wrote:
>  >> On Tue, Feb 26, 2008 at 11:00:58AM -0800, Yinghai Lu wrote:
>  >>  >
>  >>  >1. if acpi=off ?
>  >>
>  >>  Well that is not a realistic scenario for any multi chassi NUMA machine,
>  >>  since the proximity information is very important and turning acpi off
>  >>  deprives the OS of this information.
>  >
>  >actually OS should detect the distance instead of rely on SLIT.
>
>  How does it do that?  ACPI SRAT is needed to determine this, and it wouldn't
>  work if acpi=off.

srat only have apicid to node mapping, and ram to node mapping.

for amd64 system, when acpi=off
ram to node mapping can be retrieved from pci conf space
apicid to node mapping could be calculated too... with boot_cpu_id
...plus coreid bits.

YH
