Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbYIID3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbYIID3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYIID27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:28:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:47720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbYIID26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:28:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,362,1217833200"; 
   d="scan'208";a="437235843"
From: "Yang, Sheng" <sheng.yang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH 0/2] x86: Add "virt flags"
Date: Tue, 9 Sep 2008 11:32:14 +0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <12208705553277-git-send-email-sheng.yang@intel.com> <48C54527.5040205@zytor.com> <48C55E0E.2090200@zytor.com>
In-Reply-To: <48C55E0E.2090200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091132.14717.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 01:17:02 H. Peter Anvin wrote:
> H. Peter Anvin wrote:
> > Ingo Molnar wrote:
> >> hm, i think extending the already existing flags category sounds like
> >> a better solution than the separate virtual CPU flags line in
> >> /proc/cpuinfo. We already have self-invented flag entries (such as
> >> X86_FEATURE_NOPL), and adding more for virtualization would be quite
> >> natural to do, as long as it's reasonably close to the meaning of a
> >> 'CPU feature'.
> >>
> >> Peter, what would be your preference?
> >
> > It probably makes sense to separate these out as a separate word,
> > especially if they come from the hardware in any reasonable way.  But
> > yes, adding them to the feature array makes sense.
>
> Just to clarify:
>
> I'm suggesting adding these to the existing feature flags array, in a
> separate binary word.
>

Thanks! I will update the patch to add another category, and merge the array.  

-- 
regards
Yang, Sheng
> 	-hpa


