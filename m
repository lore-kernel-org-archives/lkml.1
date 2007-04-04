Return-Path: <linux-kernel-owner+w=401wt.eu-S934045AbXDDAiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbXDDAiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934048AbXDDAiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:38:55 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54877 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934045AbXDDAiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:38:54 -0400
Message-ID: <4612F394.6040105@zytor.com>
Date: Tue, 03 Apr 2007 17:38:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com> <4612F1F0.5070209@zytor.com> <4612F2BF.7080704@goop.org>
In-Reply-To: <4612F2BF.7080704@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Sounds like it would need a device which can be waited upon for changes.
> 
> A vdso-like shared page could have a futex in it.

Yes, but a futex couldn't be waited upon with a bunch of other things as 
part of a poll or a select.  The cost of reading the information is minimal.

	-hpa
