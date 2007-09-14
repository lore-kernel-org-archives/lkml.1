Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbXINVPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbXINVPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbXINVO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:14:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38109 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbXINVO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:14:56 -0400
Message-ID: <46EAF9CD.1090808@garzik.org>
Date: Fri, 14 Sep 2007 17:14:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org> <20070914211210.GB12444@fieldses.org>
In-Reply-To: <20070914211210.GB12444@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Fri, Sep 14, 2007 at 03:07:46PM -0400, Jeff Garzik wrote:
>> I've been waiting for years for a smart person to come along and write a 
>> POSIX-only distributed filesystem.

> What exactly do you mean by "POSIX-only"?

Don't bother supporting attributes, file modes, and other details not 
supported by POSIX.  The prime example being NFSv4, which is larded down 
with Windows features.

NFSv4.1 adds to the fun, by throwing interoperability completely out the 
window.

	Jeff



