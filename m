Return-Path: <linux-kernel-owner+w=401wt.eu-S1763742AbXJEWMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763742AbXJEWMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 18:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbXJEWME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 18:12:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbXJEWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 18:12:03 -0400
Message-ID: <4706B6A8.2060800@zytor.com>
Date: Fri, 05 Oct 2007 15:11:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [code] Unlimited partitions, a try
References: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 15 partitions (at least for sd_mod devices) are too few.

Now when we have 20-bit minors, can't we simply recycle some of the 
higher bits for additional partitions, across the board?  63 partitions 
seem to have been sufficient; at least I haven't heard anyone complain 
about that for 15 years.

	-hpa
