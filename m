Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbYHKWJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbYHKWJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYHKWI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:08:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYHKWI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:08:57 -0400
Message-ID: <48A0B852.4070107@zytor.com>
Date: Mon, 11 Aug 2008 15:08:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] PNP: make the resource type an unsigned long
References: <489BEA31.3040101@keyaccess.nl> <200808111559.01575.bjorn.helgaas@hp.com>
In-Reply-To: <200808111559.01575.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> 
> I see hpa's point that it makes no functional difference, but I do
> think it's worthwhile to make the types match.  I don't want to
> debug the problem that happens when somebody adds an IORESOURCE_*
> flag in the upper bits.
> 

Then half the platforms break anyway.

We should change this to an explicit type.

	-hpa

