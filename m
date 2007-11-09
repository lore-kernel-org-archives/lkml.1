Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbXKITun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbXKITun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 14:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXKITuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 14:50:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbXKITue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 14:50:34 -0500
Message-ID: <4734BA06.5050008@zytor.com>
Date: Fri, 09 Nov 2007 11:50:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23: GRUB reports "Setup signature not found"
References: <47348F54.2080507@redhat.com>
In-Reply-To: <47348F54.2080507@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Multiple people have now reported this error message with 2.6.23.
> Updating GRUB fixes it:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=370391
> https://bugzilla.redhat.com/show_bug.cgi?id=371321

This is indeed a known problem with very old versions of grub.  It would 
appear that Red Hat's rpms for grub don't actually update (some parts 
of?) grub, so it leaves an ancient grub on the system and in use.

	-hpa

