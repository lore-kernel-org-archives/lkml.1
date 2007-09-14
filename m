Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbXINWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbXINWcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 18:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbXINWcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 18:32:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36583 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338AbXINWcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 18:32:18 -0400
Message-ID: <46EB0BEB.2090808@garzik.org>
Date: Fri, 14 Sep 2007 18:32:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org> <20070914211210.GB12444@fieldses.org> <46EAF9CD.1090808@garzik.org> <20070914211828.GC12444@fieldses.org>
In-Reply-To: <20070914211828.GC12444@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Fri, Sep 14, 2007 at 05:14:53PM -0400, Jeff Garzik wrote:
>> J. Bruce Fields wrote:
>>> On Fri, Sep 14, 2007 at 03:07:46PM -0400, Jeff Garzik wrote:
>>>> I've been waiting for years for a smart person to come along and write a 
>>>> POSIX-only distributed filesystem.
>>> What exactly do you mean by "POSIX-only"?
>> Don't bother supporting attributes, file modes, and other details not 
>> supported by POSIX.  The prime example being NFSv4, which is larded down 
>> with Windows features.
> 
> I am sympathetic....  Cutting those out may still leave you with
> something pretty complicated, though.

Far less complicated than NFSv4.1 though (which is easy :))


>> NFSv4.1 adds to the fun, by throwing interoperability completely out the 
>> window.
> 
> What parts are you worried about in particular?

I'm not worried; I'm stating facts as they exist today (draft 13):

NFS v4.1 does something completely without precedent in the history of 
NFS:  the specification is defined such that interoperability is 
-impossible- to guarantee.

pNFS permits private and unspecified layout types.  This means it is 
impossible to guarantee that one NFSv4.1 implementation will be able to 
talk another NFSv4.1 implementation.

Even if Linux supports the entire NFSv4.1 RFC (as it stands in draft 13 
anyway), there is no guarantee at all that Linux will be able to store 
and retrieve data, since it's entirely possible that a proprietary 
protocol is required to access your data.

NFSv4.1 is no longer a completely open architecture.

	Jeff




