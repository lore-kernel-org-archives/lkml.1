Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYCJErb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYCJErb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 00:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYCJErX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 00:47:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYCJErW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 00:47:22 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: debug AT, AR, and selfID-complete events
Date: Mon, 10 Mar 2008 00:47:05 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803100047.05387.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 March 2008 04:49:34 pm Stefan Richter wrote:
> This adds debug printks for asynchronous transmission and reception and
> for self ID reception.  The debug code is per default deactivated by #if
> blocks.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> I am undecided whether this is OK for mainline, and whether the debug
> options should become a Kconfig option or runtime options.
>
> It may be temporarily useful to the few driver developers.  Do we want
> end users to provide us with debug logs of this kind?  Then it should
> be one or two runtime options.


My vote would be to include this sort of thing with a run-time option to 
enable the extra spew, since its a perfectly accepted standard for other 
drivers. It ought to be extremely useful in determining whats going wrong 
with end-user setups, particularly in cases where we can't reproduce the 
problem (typically for lack of having the specific hardware in-house).


-- 
Jarod Wilson
jwilson@redhat.com
