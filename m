Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZIOWoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZIOWoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZIOWo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:44:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZIOWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:44:26 -0400
Message-ID: <4AB018C0.30203@zytor.com>
Date: Tue, 15 Sep 2009 15:44:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: x86-PAT tree merge causes keyboard problems
References: <20090915205259.GA1910@phenom2.trippelsdorf.de>
In-Reply-To: <20090915205259.GA1910@phenom2.trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2009 01:52 PM, Markus Trippelsdorf wrote:
> The merge of the PAT tree today breaks certain key combinations of my
> keyboard.  For example I switch my virtual desktops with
> ctrl-alt-left/right and this combination stops working. Basically all
> keyboard combinations involving the left alt key are broken on my
> machine as a result of this merge.

> I bisected this down to:
> 
> »
> 335ef896d4c6639849d79367f0fef9abc06d121b is the first bad commit
> commit 335ef896d4c6639849d79367f0fef9abc06d121b
> Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Date:   Fri Jul 10 09:57:36 2009 -0700
> 
>     x86, pat: Add rbtree to do quick lookup in memtype tracking

I think we have a winner for the second bizarrest bug report I've ever
seen[1].  Not doubting you in any way, just that it is clearly a very
strange combination of things at play here.

We need more information about your system, the lspci -vv and dmidecode
output, as well as your entire dmesg, and a dump of
/debug/x86/pat_memtype_list.

	-hpa


[1] The bizarrest one was a floating-point bug in the original Crusoe
CPU, which ended up having the effect that a pair of double doors on a
particular level in Quake 1 would only have one of the two half-doors
swing open when the player approached.
