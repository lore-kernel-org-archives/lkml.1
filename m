Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZKLTun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZKLTun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZKLTum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:50:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZKLTum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:50:42 -0500
Message-ID: <4AFC66E7.5040900@zytor.com>
Date: Thu, 12 Nov 2009 11:49:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
References: <200911112134.34261.bzolnier@gmail.com> <20091112065930.GA9279@elte.hu> <4AFBB45A.9000606@zytor.com> <20091112081317.GB25345@elte.hu> <4AFC274C.2020209@zytor.com> <20091112175908.GB20542@elte.hu> <20091112183718.GA1925@codemonkey.org.uk>
In-Reply-To: <20091112183718.GA1925@codemonkey.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 10:37 AM, Dave Jones wrote:
> On Thu, Nov 12, 2009 at 06:59:08PM +0100, Ingo Molnar wrote:
>  > > It's an ABI.  Keep it stable, please.
>  > 
>  > That's generally true, but i'm not suggesting that: i'm suggesting to 
>  > _clear_ the HT flag from the cpufeatures if there's only one sibling. 
>  > It's meaningless in that case and as the link quoted by the original 
>  > patch shows many people are confused by that.
>  > 
>  > I have such a box so i can test it. (but i dont expect any problems)
> 
> I agree that it's an ABI change, but any software depending on its current
> state has to implement a fallback for the case where 'ht' isn't present anyway
> unless there's some program that only runs on ht capable hardware, which
> sounds just crazy.
> 
> The only potential for breakage that I can see is that code that is tuned
> to be run in the HT case will stop running in cases where it shouldn't.
> Which sounds like a positive thing to me.

The most likely breakage would be some stupid licensing scheme.

The other aspect is that we as much as possible have tried to stay to
the hardware-documented names of these strings.  Inventing new strings
is generally a bad idea.

	-hpa

