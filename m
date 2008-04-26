Return-Path: <linux-kernel-owner+w=401wt.eu-S1762720AbYDZUh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762720AbYDZUh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbYDZUhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:37:14 -0400
Received: from main.gmane.org ([80.91.229.2]:48959 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759399AbYDZUhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:37:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: mainline boot failures I: qemu
Date: Sat, 26 Apr 2008 13:37:31 -0700
Message-ID: <fv03pe$3ue$1@ger.gmane.org>
References: <20080426140210.GA13365@basil.nowhere.org> <20080426154241.GH5882@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-186-145.dsl.irvnca.pacbell.net
User-Agent: Thunderbird 3.0a1pre (X11/2008042507)
In-Reply-To: <20080426154241.GH5882@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Sat, Apr 26, 2008 at 04:02:10PM +0200, Andi Kleen wrote:
>> FYI
>>
>> I see lots of boot failures on various setups with current mainline
>> (git8, b1721d0da266b4af8cb4419473b4ca36206ab200). Unfortunately
>> they are all different.
>
> FWIW, I've reconstructed what had happened:
 > ...

When I bisected down to a commit with your name on it I was quite upset.
Only hallucinations or a rent in the fabric of space-time could explain
what my eyes were telling me ;o)

> -	struct files_struct *copy;
> +	struct files_struct *copy = NULL;

This patch works for me, thanks.

