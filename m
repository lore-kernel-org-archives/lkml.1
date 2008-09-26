Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYIZV5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYIZV5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYIZV5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:57:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbYIZV5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:57:21 -0400
Message-ID: <48DD5ABF.8030805@zytor.com>
Date: Fri, 26 Sep 2008 14:57:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joris van Rantwijk <jorispubl@xs4all.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Inflation of vmlinux by linker on x86_64
References: <20080926124222.GA49837@xs4all.nl> <48DD2F68.6000609@zytor.com> <eb34240721c0b92818908672eccecf62@xs4all.nl> <48DD40EF.4000107@zytor.com> <20080926215537.GA31124@xs4all.nl>
In-Reply-To: <20080926215537.GA31124@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joris van Rantwijk wrote:
> 
> There is still the question whether linking vmlinux with -n (turn off
> file offset alignment) works on all architectures.  I suspect not.
> 

Almost certainly not, since it creates a noncompliant ELF file.  For x86 
it is probably safe, though, but it needs to be an arch option.

	-hpa
