Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYJXB1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYJXB1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYJXB10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:27:26 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39647 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbYJXB1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:27:25 -0400
Subject: RE: Oops in ACPI with git latest
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <4911F71203A09E4D9981D27F9D830858033D1CC9@orsmsx503.amr.corp.intel.com>
References: <1224791103.3330.37.camel@localhost.localdomain>
	 <200810232242.33480.rjw@sisk.pl>
	 <4911F71203A09E4D9981D27F9D830858033D1CC9@orsmsx503.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 20:27:22 -0500
Message-Id: <1224811642.3330.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 15:34 -0700, Moore, Robert wrote:
> +	if (!output.pointer)
> +		return AE_NULL_OBJECT;
> +
> 
> This probably won't work. acpi_evaluate_object currently doesn't touch the pointer parameter if there is no return value, it only sets the length to zero.

Actually, it does.

> So, you might try this:
> 
> +	if (!output.length)
> +		return AE_NULL_OBJECT;
> +

This also works.

James


