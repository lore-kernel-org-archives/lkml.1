Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZBKOXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZBKOXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZBKOWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:22:50 -0500
Received: from fogou.chygwyn.com ([195.171.2.24]:52198 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZBKOWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:22:49 -0500
X-Greylist: delayed 2469 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 09:22:49 EST
Date: Wed, 11 Feb 2009 13:36:48 +0000
From: steve@chygwyn.com
To: Kirill Kuvaldin <kirill.kuvaldin@gmail.com>
Cc: linux-cluster@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: GFS2 file locking issues
Message-ID: <20090211133648.GA10273@fogou.chygwyn.com>
References: <2d42915c0902110255k3c0741a9s6830765bce6be052@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d42915c0902110255k3c0741a9s6830765bce6be052@mail.gmail.com>
Organization: ChyGwyn Limited
X-Registered-Office: Digital Technium, Singleton Park, Swansea. SA2 8PP
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 11, 2009 at 01:55:08PM +0300, Kirill Kuvaldin wrote:
> Hi,
> 
> I'm trying to understand how the FS locking mechanism should work.
> 
> I'm running a clustered GFS2 across two nodes, each node is a Xen domU.
> To check if locking works correctly I wrote the simple perl script below.
> Basically the script opens a file, locks it to prevent others from
> writing into it, writes 20 lines into it, then unlocks and closes.
>i

It should be exactly the same on GFS and GFS2, after all the code for
flock is almost identical between the two. What mount options did you
use? Which lock manager are you using - I presume lock_dlm?

Steve.
