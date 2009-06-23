Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZFWXqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZFWXqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZFWXqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:46:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:41085 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbZFWXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=U0OnHcYxkLKRL6vgeGw5FSl8qYjXlaW6spTsBTxN0gy8IOQejEzBr05dRPL5LCsly4
         zsnoh3gwMPfnR2Q2kJIOO97bcm5B/3qWmGvKdOdsgyYXC+Mq/7a46utWkI0dp1ArQIua
         RAybAc2ZaqsH2SZskCSGaU38d2ZhC8ldFuNzo=
Message-ID: <4A416952.2050809@laptop.org>
Date: Tue, 23 Jun 2009 19:46:26 -0400
From: "Richard A. Smith" <richard@laptop.org>
Reply-To: richard@laptop.org
Organization: One Laptop per Child
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and
 add it to the olpc driver
References: <20090622234607.11f61bec@mycelium.queued.net> <20090623103717.GH5422@sirena.org.uk> <4A412CC0.6050500@laptop.org> <20090623224434.GB16188@opensource.wolfsonmicro.com> <4A41618D.4020900@laptop.org> <20090623232537.GE16188@opensource.wolfsonmicro.com>
In-Reply-To: <20090623232537.GE16188@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Tue, Jun 23, 2009 at 07:13:17PM -0400, Richard A. Smith wrote:
>> Mark Brown wrote:
> 
>>> A separate file with the detailed information would sidestep this since
>>> it's a new interface.  I'm not strongly opposed to adding the new states
>>> but I do think it's worth considering other ways of doing this.
> 
>> I've got no problems with a new interface.  But, i'm also not the person  
>> writing the driver. :)
> 
> It's really no bother from the driver point of view either way, it's the
> user space applications that are the concern here - are they going to
> cope well with a new state appearing there?

I can only speak for OLPC's usage.  But my script, the documentation on 
our wiki, and HAL are the only things that I know of that use that info 
and none of them should have any problem with it changing.

-- 
Richard Smith  <richard@laptop.org>
One Laptop Per Child
