Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbYA1Ux2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbYA1Ux2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYA1UxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:53:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40518 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYA1UxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:53:19 -0500
Date: Mon, 28 Jan 2008 21:53:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Zan Lynx <zlynx@acm.org>
cc: Jason Price <japrice@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: show label for swap partition.
In-Reply-To: <1201551042.9135.5.camel@localhost>
Message-ID: <Pine.LNX.4.64.0801282152380.1185@fbirervta.pbzchgretzou.qr>
References: <83f15e30801281151w21466ef9m82dc50ab09dc390f@mail.gmail.com> 
 <83f15e30801281156od91c2a8p3ec439cb16232386@mail.gmail.com> 
 <83f15e30801281158s36b0da3el210f5a97b0348ea3@mail.gmail.com>
 <1201551042.9135.5.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 28 2008 20:10, Zan Lynx wrote:
>On Mon, 2008-01-28 at 14:58 -0500, Jason Price wrote:
>> I apologize if this is the wrong forum.  Please CC me on replies.
>> 
>> A admin accidentally deleted the swap line from the fstab file.  We
>> mount the swap filesystem via labels.  However, there seems to be no
>> way to list the label on an existing swap partition, via the command
>> line swap tools (mkswap, swapon/off, etc)
>> 
>> Is this blindness on my part, or should there be an analog to e2label
>> for swap partitions?

# blkid /dev/mapper/swap0
swap0: UUID="502e549d-d8b4-4c08-9b27-3d3e9cefed92" TYPE="swap" 

Works.

