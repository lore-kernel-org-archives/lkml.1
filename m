Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053Ab0A2PKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0A2PKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 10:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252Ab0A2PKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 10:10:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab0A2PKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 10:10:01 -0500
Message-ID: <4B62FA46.9080602@redhat.com>
Date: Fri, 29 Jan 2010 10:09:58 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Derek Atkins <warlord@mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Re-enabling non-GPL driver access to disk partition information
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
In-Reply-To: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 09:15 AM, Derek Atkins wrote:
> Hi Linuxers,
>
> I've been working on a proprietary disk driver which has been working
> for the past couple years on Linux as old as 2.6.18.  Unfortunately,
> as of 2.6.28 it appears that some of the gendisk interfaces (read:
> structure members) I was using were moved behind an RCU and other
> GPL-ONLY accessor interfaces.

RCU is patented, with permission for GPL code to use the algorithm.

Exposing RCU bits to non-GPL modules would be rather pointless, since
those don't have permission (from IBM, the RCU patent holder) to use
RCU, anyway.

-- 
All rights reversed.
