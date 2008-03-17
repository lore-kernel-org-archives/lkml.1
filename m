Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbYCQQmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbYCQQmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYCQQmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:42:14 -0400
Received: from outbound-mail-114.bluehost.com ([69.89.24.4]:35768 "HELO
	outbound-mail-114.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751532AbYCQQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:42:14 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2008 12:42:13 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: trim mtrr don't close gap for resource allocation
Date: Mon, 17 Mar 2008 09:35:18 -0700
User-Agent: KMail/1.9.9
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, steve@lobefin.net,
       "Andi Kleen" <ak@suse.de>,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>
References: <86802c440803161738v77c8e6a7s360cc8672ec17bb0@mail.gmail.com>
In-Reply-To: <86802c440803161738v77c8e6a7s360cc8672ec17bb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803170935.19106.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new function could probably use some higher level comments (though the 
rest of the e820 routines seem similarly devoid of description so it's not a 
big deal).  And given that this patch fixes a regression, it should probably 
get upstream quickly.

Thanks for fixing this so quickly, Yinghai.

Acked-by:  Jesse Barnes <jesse.barnes@intel.com>
