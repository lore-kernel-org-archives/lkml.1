Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZEJNUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZEJNUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 09:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZEJNUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 09:20:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:21379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZEJNUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 09:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <20090510225246.0a77b557.sfr@canb.auug.org.au>
References: <20090509142601.874865281@blue.kroah.org> <20090509143631.276407654@blue.kroah.org> 
	<20090510225246.0a77b557.sfr@canb.auug.org.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 10 May 2009 15:19:46 +0200
Message-ID: <ac3eb2510905100619j2a76409fh775f42e4a745b4@mail.gmail.com>
Subject: Re: [patch 01/13] Driver Core: add nodename callbacks
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 14:52, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>> +++ b/include/linux/device.h
>>  struct device {
>>       struct device           *parent;
>> +     char *(*nodename)(struct device *dev);
>
> Just wondering what this callback is for.  I didn't look really hard, but
> couldn't find it used anywhere.

You are right, that seems like a left-over which did not get used, and
should be removed from the patch.

Thanks a lot for checking,
Kay
