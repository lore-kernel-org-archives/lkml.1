Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbYE2AKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbYE2AKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 20:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYE2AJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 20:09:59 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45334 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYE2AJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 20:09:59 -0400
Date: Wed, 28 May 2008 18:11:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libata - DMA problems ICH7 rev 02
In-reply-to: <8dacd7b30805280636p34097a84t6f7e5c7ebe98747a@mail.gmail.com>
To: Jan Niklas Hasse <jhasse@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Message-id: <483DF4CD.3020107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.6VoLd5Q2gfHHZZfYneNkQcGjXKk@ifi.uio.no>
 <fa.kzdMLVO0bqLAbXEBqWrKyBntgxc@ifi.uio.no>
 <fa.h4D6h2c4Yz08K7snVTVtewbsziM@ifi.uio.no> <481BD00E.7050302@shaw.ca>
 <8dacd7b30805120855q406f566ma187142719bf5bd4@mail.gmail.com>
 <4828DEE1.1070905@shaw.ca>
 <8dacd7b30805280634s77492f0ag15ee65150f8bedad@mail.gmail.com>
 <8dacd7b30805280636p34097a84t6f7e5c7ebe98747a@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Niklas Hasse wrote:
> On Wed, May 28, 2008 at 3:34 PM, Jan Niklas Hasse <jhasse@gmail.com> wrote:
>>> It looks like you have the hard drive and the burner on the same IDE channel? Such problems are unavoidable in this setup since commands to one device on the channel can't execute while the other device is busy (especially for long commands like finalizing the disc). It would be better to move the drives onto separate channels.
> 
> As I have a notebook, I think I can't do that, can I?

Likely not, no. That is pretty poor design by the manufacturer, to set 
things up that way..
