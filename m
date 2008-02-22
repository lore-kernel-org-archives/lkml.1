Return-Path: <linux-kernel-owner+w=401wt.eu-S936302AbYBVAsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936302AbYBVAsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764308AbYBVAs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:48:29 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:5412 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764129AbYBVAs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:48:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P5ntwHkMDgNSLx96xbdoTB4q9fsOJ2lS4GdThUOhAk2VFK2E4nbHXU+62/0tzZPG285sJJNbP2Z8etDTOjW/uJpgI2TRmqmdxaNLdm7KYa/54nKnyQaJryZIRl+lBHll5vtHglkG8vo7zxlHg4GbESAMYObPIN14m2lqTVaScq0=
Message-ID: <b6a2187b0802211648u2d420861v2cc4d06ba659daf2@mail.gmail.com>
Date: Fri, 22 Feb 2008 08:48:26 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Dave Airlie" <airlied@linux.ie>,
       "Greg KH" <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200802211545.05794.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802211034.22056.jesse.barnes@intel.com>
	 <200802212311.44319.rjw@sisk.pl>
	 <200802211545.05794.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 7:45 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> On Thursday, February 21, 2008 2:11 pm Rafael J. Wysocki wrote:
>  > Below is a patch that should work around the issue.  Please try it and let
>  > me know if it helps.
>
>  I ended up applying the below patch instead, so it would build, and
>  unfortunately it still hung at suspend time.

I encountered the same patching problem, but realized that it was due
to earlier patch that you had wanted me to test, so if you revert your
patch back to the current git, Rafael's patch will apply and compile
cleanly.

Thanks,
Jeff.
