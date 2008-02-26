Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbYBZXlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbYBZXlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYBZXle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:41:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:37502 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYBZXld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:41:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=blmAP1NXMGk9GSKNi4FBz9WIsTR1EONrMlEYRa2RVaEVSLUYdTmJMcF/7PPAr/YGEu1wJDT1zezyk1qVgGijp4bDi3LpXvLWAShJwAQkK3kUDULFM1Y7c3fB7jWMEZD/fqI/UfUA/V3N/Xb945R1v+GTCZNCNoDTMURYzF4nj1s=
Message-ID: <86802c440802261541s67810687pb7079200288c1e20@mail.gmail.com>
Date: Tue, 26 Feb 2008 15:41:27 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran Thirumalai" <kiran@scalemp.com>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
In-Reply-To: <20080226233111.GA9734@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080226033945.GJ3143@localdomain>
	 <20080226040541.GK3143@localdomain>
	 <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com>
	 <20080226184235.GA5914@localdomain>
	 <86802c440802261100j322ee6a6yef9108dc175de459@mail.gmail.com>
	 <20080226203235.GH5914@localdomain>
	 <86802c440802261310y176cdfel38843e264bc71f82@mail.gmail.com>
	 <20080226212418.GJ5914@localdomain>
	 <86802c440802261516n1ca8ef6eh5e6abdd0c3f959dd@mail.gmail.com>
	 <20080226233111.GA9734@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 3:31 PM, Ravikiran Thirumalai <kiran@scalemp.com> wrote:
> On Tue, Feb 26, 2008 at 03:16:16PM -0800, Yinghai Lu wrote:
>  >On Tue, Feb 26, 2008 at 1:24 PM, Ravikiran Thirumalai <kiran@scalemp.com> wrote:
>  >>
>  >> On Tue, Feb 26, 2008 at 01:10:57PM -0800, Yinghai Lu wrote:
>  >>  >On Tue, Feb 26, 2008 at 12:32 PM, Ravikiran Thirumalai
>  >>  ><kiran@scalemp.com> wrote:
>  >>  >> On Tue, Feb 26, 2008 at 11:00:58AM -0800, Yinghai Lu wrote:
>  >>  >>  >
>  >>  >>  >1. if acpi=off ?
>  >>  >>
>  >>  >>  Well that is not a realistic scenario for any multi chassi NUMA machine,
>  >>  >>  since the proximity information is very important and turning acpi off
>  >>  >>  deprives the OS of this information.
>  >>  >
>  >>  >actually OS should detect the distance instead of rely on SLIT.
>  >>
>  >>  How does it do that?  ACPI SRAT is needed to determine this, and it wouldn't
>  >>  work if acpi=off.
>  >
>  >srat only have apicid to node mapping, and ram to node mapping.
>
>  Which is very important for performance.
>
>
>  >
>  >for amd64 system, when acpi=off
>  >ram to node mapping can be retrieved from pci conf space
>
>  I was referring to all types of numa systems, not just AMD.  The pci config
>  space is amd specific.  Multi chassi systems in particular would be
>  acpi SRAT based.  Anyways.

can you try x86.git#testing your vsmp to see if is_vsmp_box is working?

http://people.redhat.com/mingo/x86.git/README

YH
