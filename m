Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbYH2Fyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbYH2Fyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 01:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYH2Fyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 01:54:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:60892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbYH2Fyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 01:54:43 -0400
Message-ID: <48B78EBA.609@kernel.org>
Date: Fri, 29 Aug 2008 07:52:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mike Hommey <mh@glandium.org>
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
References: <1219947544-666-1-git-send-email-tj@kernel.org> <20080829055000.GB18930@glandium.org>
In-Reply-To: <20080829055000.GB18930@glandium.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 05:54:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Hommey wrote:
> On Fri, Aug 29, 2008 at 03:18:59AM +0900, Tejun Heo wrote:
>> This patchset implements CUSE - Character device in Userspace.  Except
>> for initialization sequence and creation of character device instead
>> of a mount, CUSE isn't very different from FUSE.
> 
> It would be nice to have BUSE, Block device in Userspace, too.

Thought about that but it's really no different from nbd or loop
depending on your application and block devices don't really implement
the file operations so it won't have too much in common with FUSE.
Also, there's the complication of going out to disk for more memory cases.

-- 
tejun
