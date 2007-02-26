Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbXBZHxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbXBZHxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933787AbXBZHxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:53:44 -0500
Received: from terminus.zytor.com ([192.83.249.54]:55765 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933753AbXBZHxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:53:43 -0500
Message-ID: <45E291F7.6060508@zytor.com>
Date: Sun, 25 Feb 2007 23:53:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>	 <20070226003307.6f38d2ee@lxorguk.ukuu.org.uk> <84144f020702252325j29da2819i50c99477cce89359@mail.gmail.com>
In-Reply-To: <84144f020702252325j29da2819i50c99477cce89359@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Alan,
> 
> On 2/26/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
>> Whats the status on this, I was suprised to see something so important
>> just go dead ?
> 
> It's not dead. You can find the latest patches here:
> 
> http://www.cs.helsinki.fi/u/penberg/linux/revoke/patches/
> 
> and user-space tests here:
> 
> http://www.cs.helsinki.fi/u/penberg/linux/revoke/utils/
> 
> What they are lacking is review so I am not sure how to proceed with
> the patches.
> 

On this general subject, would it make sense to, for the future, have 
system calls of the -at() form only, and specify that the f- system 
calls take (fd, NULL) as the (file descriptor, filename) tuple?

	-hpa
