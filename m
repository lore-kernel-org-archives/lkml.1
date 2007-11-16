Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbXKPHO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbXKPHO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXKPHOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:14:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:18890 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXKPHOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:14:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fFEf1J7Ar5znvSI2mjX7PFnGCmkbO1ELzhMiTDIgZxvsz0LxMHjyEp7MIvKg1tQu07jn91/wBEUdMs71VLw14LDh/7E1XvcAGmpnMz6sXjLHrZT4KwGDq10hBjM64uDlKHXec1XckrgWLuytz1N3Sc6dTmYJqMiHpeQJAeCcndA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] intel-iommu fixes
Date: Thu, 15 Nov 2007 23:14:33 -0800
User-Agent: KMail/1.9.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org
References: <20071029045116.GB8181@ftp.linux.org.uk>
In-Reply-To: <20071029045116.GB8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711152314.33973.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 October 2007 21:51, Al Viro wrote:
> -#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings)
> +#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings) - 1

The macro is unsafe without yet another ()s around it.
--
vda
