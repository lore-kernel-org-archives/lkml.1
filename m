Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbYBGS2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbYBGS2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYBGS2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:28:03 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:47328 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbYBGS2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:28:00 -0500
Message-ID: <47AB4C68.1080308@qualcomm.com>
Date: Thu, 07 Feb 2008 10:22:32 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] CPU isolation extensions
References: <47AA9807.7090402@qualcomm.com>	<20080206215805.17a0c919.akpm@linux-foundation.org>	<20080207015954.92cd3878.pj@sgi.com>	<47AB47C1.1070208@qualcomm.com> <20080207121040.42efad60.pj@sgi.com>
In-Reply-To: <20080207121040.42efad60.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Max - Andrew wondered if the rt tree had seen the
> code or commented it on it.  What became of that?
I just replied to Andrew. It's not an RT feature per se.
And yes Peter CC'ed RT folks. You probably did not get a chance to read all replies.
They had some questions/concerns and stuff. I believe I answered/clarified all of them.

> My two cents isn't worth a plug nickel here, but
> I'm inclined to nod in agreement when Linus wants
> to see these patches get some more exposure before
> going into Linus's tree.  ... what's the hurry?
No hurry I guess. I did mentioned in the introductory email that I've been maintaining 
this stuff for awhile now. SLAB patches used to be messy, with new SLUB the mess goes away.
CFS handles CPU hotplug much better than O(1), cpu hotplug is needed to be able to change
isolated bit from sysfs. That's why I think it's a good time to merge.
I don't mind of course if we put this stuff in -mm first. Although first part of the patchset 
(ie exporting isolated map, sysfs interface, etc) seem very simple and totally not controversial.
Stop machine patch is really the only thing that may look suspicious. 
 
Max
