Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbYDJMX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbYDJMX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYDJMXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:23:18 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:31097 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYDJMXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QCYq8pP4haJFSxTrxmMff2IZ4FhSWgTU0SDkyBVutxe3N6AvMZaqM4COK0G0CKTvyt1HZ1oVFFuEFNpAPTp6NAeynY1Nncfyem6uXYq+Ei1+FALmmvBvz3pSIxtXw+jE0KkxG5kjk+PR9KhbyUDCtWO4oenX9ojo3AjPqkRvQzA=
Message-ID: <f7430a760804100523t6483dc0cn144429ee7024a7f2@mail.gmail.com>
Date: Thu, 10 Apr 2008 14:23:15 +0200
From: NoWhereMan <uncommonnonsense@gmail.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>
Subject: Re: [PATCH 2.6.25-rc7 001/001] ACPI: workaround for buggy BIOS to ignore error LINK CRS method
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Len Brown" <lenb@kernel.org>
In-Reply-To: <1207824057.8704.12.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7430a760804090842s44ece7bh216d5d28e347955@mail.gmail.com>
	 <20080409161251.0c0e73e9.akpm@linux-foundation.org>
	 <1207824057.8704.12.camel@yakui_zhao.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 12:40 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
> On Wed, 2008-04-09 at 16:12 -0700, Andrew Morton wrote:

>  > That patch is about four months old.  Hopefully there was a reason why we
>  > dodn't proceed with it?
>  It seems that the system can work after applying the patch.
>  But the patch depends on the returned result(-ENODEV).
>  > if (ACPI_FAILURE(status)) {
>  >               ACPI_EXCEPTION((AE_INFO, status, "Evaluating _CRS"));
>  >                result = -ENODEV;
>   >               goto end;
>   >       }
>  Now I am writing another workaround patch about this problem.

I'll try to help, testing the new patch on my system
