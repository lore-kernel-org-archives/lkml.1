Return-Path: <linux-kernel-owner+w=401wt.eu-S935078AbXLPRex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078AbXLPRex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 12:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934282AbXLPReq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 12:34:46 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:12753 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037AbXLPRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 12:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type:from;
        b=MlYmUDcuGFbAVDMC0OZfZDnvMaCP9cB6B53tHXqcXE88hXfa/s+8Japs0Re3VT6LSYnt+N9ZOwR3YyrJPjYKlcK/o+s9jjIhSW0nby4geXWQGc7lCVck4EPO9G//FtSUS2doENdJrbS6KramimDjekIxV9ctgurbi6LhQZUuXqE=
Date: Sun, 16 Dec 2007 12:34:33 -0500 (EST)
To: devzero@web.de
cc: linux-kernel@vger.kernel.org, Matt.Domsch@dell.com, hpa@zytor.com
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
In-Reply-To: <49015158@web.de>
Message-ID: <Pine.LNX.4.64.0712161127180.4465@mini.warudkars.net>
References: <49015158@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007, devzero@web.de wrote:

>
> - it seems there are buggy Bios implementations out there which have problems with EDD
> - your favourite distro may have set CONFIG_EDD=y|m , so EDD probe is on by default quite often nowadays.
> - setting "edd=off" when you get that hang on boot is _not_ obvious.

It does not look like this issue is common - googling for "Linux EDD Boot 
hang" does not bring up relevant and recent results - in fact this post of 
yours comes on top. Further more there does not seem to be problems with 
newer BIOSes so we would be irritating lot many users needlessly.

Adding 3 printks for each such obscure problem would make it even more 
complex to parse and make sense of the boot log - I, for example, already 
dislike the mostly-useless-to-end-user stuff it spews on a normal boot.

If there are known chipsets / BIOSes that have this problem - applying 
quirks - something like this quirk for pmtmr [1]- (if they work this 
early) or even special casing them with forced edd=off may be the right and more useful thing to do.

[1] http://www.webservertalk.com/archive242-2006-3-1447442.html

Parag
