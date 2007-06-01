Return-Path: <linux-kernel-owner+w=401wt.eu-S1762508AbXFAQr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762508AbXFAQr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761297AbXFAQru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:47:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:44510 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760933AbXFAQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UU6MApJ/DKis/9Op5vDpvmE0ri2v1nju3ZAZu+7mowhukHnfVaqWjUTZtWumq49AOozwsRk3tUCGa29z64nX7dUsz5FLk9KMI3wKWEZjuWLyXxQw29/VABLM409lL8HfkXIS1MBcHbv+oo9pavPh0np9C2F8Am1UQT4ps8GHfek=
Message-ID: <86802c440706010947j460ccc71l6dacb8df497b5f60@mail.gmail.com>
Date: Fri, 1 Jun 2007 09:47:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "chandramouli narayanan" <mouli@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH 2.6.21 1/3] x86_64: EFI64 support
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       ak@suse.de, akpm@linux-foundation.org
In-Reply-To: <463A35FE.3080501@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
	 <20070501190110.770881000@em64tdvp.jf.intel.com>
	 <20070502195635.6fcc59d6.randy.dunlap@oracle.com>
	 <463A35FE.3080501@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, chandramouli narayanan <mouli@linux.intel.com> wrote:
> Randy Dunlap wrote:
> > Can you share EFI code as much as possible among ia64, i386,
> > and x86_64 instead of duplicating it?
> Hi Randy,
>
> Based on the feedback from Andi and you, these are the areas:
>
> 1. conversion of EFI memory map to e820 map

for the e820 map, is supposed to bootloader to converting, and pass
that via real_mode_data. right?

YH
