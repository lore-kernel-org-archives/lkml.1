Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYKDHyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYKDHyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYKDHx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:53:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:65067 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYKDHxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:53:55 -0500
Message-ID: <f488382f0811032353q1eb5b7fdjf617f3a5ea96b1f@mail.gmail.com>
Date: Mon, 3 Nov 2008 23:53:53 -0800
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] EHCI pci-quirks.c: wait for BIOS handoff too long
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <greg@kroah.com>
In-Reply-To: <490FFE1A.30606@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225774635-15032-1-git-send-email-steven@uplinklabs.net>
	 <490FDE72.9060400@garzik.org> <200811032251.47110.david-b@pacbell.net>
	 <490FFE1A.30606@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 11:47 PM, Jeff Garzik <jeff@garzik.org> wrote:
> David Brownell wrote:
>>
>> On Monday 03 November 2008, Jeff Garzik wrote:
>>>
>>> That tells us nothing about the original reason for choosing the 5000
>>> value, and what if any impact lowering the value has on those who thought
>>> 5000 was needed.
>>
>> You mean, the source code should have a comment about that?
>
> I was thinking changeset description (email body), but source code comment
> works too.
>
>        Jeff
>

I really need to start getting into the habit of 'reply to all'.
Apologies for the extra email, Jeff:



 Sorry, I should really be more verbose in the commit log.

 The five second delay is really quite irritating to have to deal with
 every boot up, and I very seriously doubt any non-broken bios takes
 more than a second to do the actual handoff.

 - Steven


>
>
>
