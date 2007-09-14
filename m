Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXINWmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXINWmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 18:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbXINWmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 18:42:22 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52278 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843AbXINWmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 18:42:21 -0400
Date: Fri, 14 Sep 2007 18:42:12 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
Message-ID: <20070914224212.GJ12444@fieldses.org>
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org> <20070914211210.GB12444@fieldses.org> <46EAF9CD.1090808@garzik.org> <20070914211828.GC12444@fieldses.org> <46EB0BEB.2090808@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EB0BEB.2090808@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 06:32:11PM -0400, Jeff Garzik wrote:
> J. Bruce Fields wrote:
>> On Fri, Sep 14, 2007 at 05:14:53PM -0400, Jeff Garzik wrote:
>>> J. Bruce Fields wrote:
>>>> On Fri, Sep 14, 2007 at 03:07:46PM -0400, Jeff Garzik wrote:
>>>>> I've been waiting for years for a smart person to come along and write 
>>>>> a POSIX-only distributed filesystem.
>>>> What exactly do you mean by "POSIX-only"?
>>> Don't bother supporting attributes, file modes, and other details not 
>>> supported by POSIX.  The prime example being NFSv4, which is larded down 
>>> with Windows features.
>> I am sympathetic....  Cutting those out may still leave you with
>> something pretty complicated, though.
>
> Far less complicated than NFSv4.1 though (which is easy :))

One would hope so.

>>> NFSv4.1 adds to the fun, by throwing interoperability completely out the 
>>> window.
>> What parts are you worried about in particular?
>
> I'm not worried; I'm stating facts as they exist today (draft 13):
>
> NFS v4.1 does something completely without precedent in the history of NFS: 
>  the specification is defined such that interoperability is -impossible- to 
> guarantee.
>
> pNFS permits private and unspecified layout types.  This means it is 
> impossible to guarantee that one NFSv4.1 implementation will be able to 
> talk another NFSv4.1 implementation.

No, servers are required to support ordinary nfs operations to the
metadata server.

At least, that's the way it was last I heard, which was a while ago.  I
agree that it'd stink (for any number of reasons) if you ever *had* to
get a layout to access some file.

Was that your main concern?

--b.
