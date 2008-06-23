Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYFWCQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYFWCQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYFWCQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:16:26 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:48581 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbYFWCQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dEKznTHqE1aUwWUGYg7QXrt/RFprUOjxnPPT+vle4dNiEwioC3kii371t7C/Xaubzs
         Q/8FbryBUg0FassTtBb2Y/Rrxc+H87RtRNWD+JsOdZacn3qbhceDu+MjX536zZbHKGch
         Cby6uk7dsFRDr0eELnYfr283EVXJj0TIW/rJ4=
Message-ID: <485F076C.8040402@gmail.com>
Date: Mon, 23 Jun 2008 11:16:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Benjamin Thery <benjamin.thery@bull.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 09/11] sysfs: add sysfs_ns_exit routine
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170731.450724863@theryb.frec.bull.fr>
In-Reply-To: <20080618170731.450724863@theryb.frec.bull.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Thery wrote:
> Add sysfs routine sysfs_ns_exit() to allow a namespace to go away while
> sysfs is still mounted. 
> 
> The exiting namespace calls this routine and pass it a callback to be 
> called for every sysfs superblocks present. The callback contains the 
> necessary code to clean the superblock tag data associated with this 
> namespace.
> 
> Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>

Similar object to earlier dynamic tag thing.  Can't we just have
something like sysfs_murder_sb(sb) where @sb represents a ns?

-- 
tejun
