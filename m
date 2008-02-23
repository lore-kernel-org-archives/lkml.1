Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbYBWEhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbYBWEhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 23:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYBWEgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 23:36:51 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:38821 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYBWEgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 23:36:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nR5bdQE1AS49RnlHG5DKflP5Vmdm52U08qAKoOP4iou6UBkXXZLnLWtSRM8V8K4X/yXHBNErP6aR9gmDyy508TQWJmYxlpaSzHBJ4+o66vkmmC3WBLpsnA3/5bLYfv/08KQ4G0l9jy6ZPYF/QS4rY//dDlFO+IZ42axkEocvg4E=
Message-ID: <b6a2187b0802222036i33d5bcc2n4e3bafd6d846cc09@mail.gmail.com>
Date: Sat, 23 Feb 2008 12:36:48 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: i915 hibernation patch (was: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Jesse Barnes" <jesse.barnes@intel.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802221805540.21332@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802230031.20292.rjw@sisk.pl>
	 <alpine.LFD.1.00.0802221653000.21332@woody.linux-foundation.org>
	 <200802230255.54510.rjw@sisk.pl>
	 <alpine.LFD.1.00.0802221805540.21332@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 10:07 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

>  On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:
>  > OK, please have a look at the modified patch below.
>
>  All right, I'm fine with it. Now we just need to confirm that it works for
>  people..

Looks good. Applied Rafael patch on top of your latest git tree that
has Jesse's i915 fix.

No green screen. Tested with STD (platform), STR, and plain echo mem >
/sys/power/state.

Thanks,
Jeff.
