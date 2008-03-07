Return-Path: <linux-kernel-owner+w=401wt.eu-S1759870AbYCGG3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbYCGG3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYCGG3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:29:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYCGG3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:29:43 -0500
Message-ID: <47D0E0D4.408@zytor.com>
Date: Thu, 06 Mar 2008 22:29:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: What does a Kernel Error 4 mean?
References: <521608.73353.qm@web52503.mail.re2.yahoo.com>
In-Reply-To: <521608.73353.qm@web52503.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> What does a Kernel Error 4 mean? I'm getting this
> running 64 bit Exim. Just trying to track it down and
> wondering what an "Error 4" is?

Probably:

#define EINTR            4      /* Interrupted system call */

EINTR should be a non-fatal error; the fact that Exim reports it as an 
error probably indicates an Exim bug.

Of course, it could mean something completely different.

	-hpa
