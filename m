Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXINVSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXINVSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbXINVSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:18:33 -0400
Received: from mail.fieldses.org ([66.93.2.214]:44984 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbXINVSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:18:32 -0400
Date: Fri, 14 Sep 2007 17:18:28 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
Message-ID: <20070914211828.GC12444@fieldses.org>
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org> <20070914211210.GB12444@fieldses.org> <46EAF9CD.1090808@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EAF9CD.1090808@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 05:14:53PM -0400, Jeff Garzik wrote:
> J. Bruce Fields wrote:
>> On Fri, Sep 14, 2007 at 03:07:46PM -0400, Jeff Garzik wrote:
>>> I've been waiting for years for a smart person to come along and write a 
>>> POSIX-only distributed filesystem.
>
>> What exactly do you mean by "POSIX-only"?
>
> Don't bother supporting attributes, file modes, and other details not 
> supported by POSIX.  The prime example being NFSv4, which is larded down 
> with Windows features.

I am sympathetic....  Cutting those out may still leave you with
something pretty complicated, though.

> NFSv4.1 adds to the fun, by throwing interoperability completely out the 
> window.

What parts are you worried about in particular?

--b.
