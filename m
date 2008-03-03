Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbYCCKdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbYCCKdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYCCKdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:33:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:60471 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYCCKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:33:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IflGfrZGSHNpe8UTjW9t/vJhxgNF1d10Xl8UrS5b5Z57VfmWHTbMeerHBpRxtSQLQwsu3tJaXCFmmTStabRax/L/lmxsm6wsWYddm7pzx/l0Kdu7qpyPr2JH2uWy2M5E5SaAn5PlGK8oozGEwYyEBSZGxLvcwVYGoMosYZ+hIa8=
Message-ID: <86802c440803030233s1b0cc0a6nbed683ee3d4fac63@mail.gmail.com>
Date: Mon, 3 Mar 2008 02:33:12 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] ACPI: Unneccessary to scan the PCI bus already scanned.
Cc: "Greg KH" <gregkh@suse.de>, "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Zhao Yakui" <yakui.zhao@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080303101040.GG18281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204525186.4080.11.camel@yakui_zhao.sh.intel.com>
	 <20080303073214.GA5934@elte.hu>
	 <86802c440803030006m1879838awc238f07bc98ed43e@mail.gmail.com>
	 <86802c440803030030p4ff9cec5tdb25d1cdc131d377@mail.gmail.com>
	 <86802c440803030201i684f31c1m97fb3f1f1927d4f4@mail.gmail.com>
	 <20080303101040.GG18281@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 2:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>
> > also please use attached patch to replace the one patch in x86.git#
>  > testing. old one can not be applied after Yakui's patch.
>
>  ok, thanks. Note, i still have the patch below filed up against it - is
>  that still needed?
>
>         Ingo
>
>  -------------->
>  Subject: x86: fix k8-bus_64.c build
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Wed Feb 20 10:30:15 CET 2008
>

yes. still needed, or you can fold that to next one about multi pci root.

YH
