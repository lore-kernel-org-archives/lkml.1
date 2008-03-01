Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbYCAIhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbYCAIhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 03:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbYCAIgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:36:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:33656 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbYCAIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:36:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lqdMmaJ+GKQuk93kId0aSW4X97fV8EZiO9kxOiwL4/gOI0fymuD9nuXLRJvJnOBWQPY0asCV0MynLgVRmMYTWmtuaVuijvr9eWcsaR4jNSLeT8rJaxVgU7FWPJ2mQg70N6koX3SM0epRRcg6rSc+RjiXgaFRQ8vmCzc5AkAME9k=
Message-ID: <86802c440803010036u2cb89a30h2adb90b3ee497cfc@mail.gmail.com>
Date: Sat, 1 Mar 2008 00:36:50 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] x86 pci: remove checking type for mmconfig probe v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080301060236.GE20032@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802271639.52958.yinghai.lu@sun.com>
	 <200802282356.50496.yinghai.lu@sun.com>
	 <20080301060236.GE20032@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 10:02 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Feb 28, 2008 at 11:56:50PM -0800, Yinghai Lu wrote:
>  >
>  > doesn't need to check if it is type1 or type2. we can use raw_pci_ops dirctly.
>
>  Why?  is this because the ops are already set up?  It would be nice to
>  add the "why this change is necessary and/or possible now" for the
>  changelog.
yes.
raw_pci_ops got assigned when check direct_type1 and direct_type2.
and could used in hostbridge check to get MMCONF base.

make mmconfig probe clean
with checking if raw_pci_ops is assigned instead of passing type or
checking type.

YH
