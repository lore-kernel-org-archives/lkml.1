Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYBLCYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYBLCYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 21:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYBLCX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 21:23:57 -0500
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:35008 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752515AbYBLCX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:23:57 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.25-rc1 regression - suspend to ram
Date: Mon, 11 Feb 2008 15:16:11 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
References: <20080211225811.GB4343@ics.muni.cz>
In-Reply-To: <20080211225811.GB4343@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111516.11640.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2008 2:58 pm Lukas Hejtmanek wrote:
> Hello,
>
> 2.6.25-rc1 takes really long time till it suspends (about 30-40secs, used
> to be about 5 secs at all) and it is resuming about few minutes.  While
> resuming, capslock toggles the capslock led but with few secs delay.
>
> 2.6.24-git15 was OK. 2.6.24 is OK.
>
> I have Lenovo ThinkPad T61.

Oh, you're lucky, I couldn't get my T61 to suspend at all with 2.6.25-rc1...  

Len found that it'll work again with idle=poll, but that'll cost you a lot of 
battery life...

Oh and make sure you have i915 loaded before you suspend if you want your text 
console to come back.

Jesse
