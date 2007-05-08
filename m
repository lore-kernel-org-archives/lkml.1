Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXEHWHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXEHWHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXEHWHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:07:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:57501 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbXEHWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qBaWZrhH2g63Ba4s9+Z0m6I35LCFiHLiEz/p/bgl5yc8BEHuOqgVZX5UatprA9xBL+InmFLNJiriaWimSrVWWyW7lbfua9BS84vBI3Ug5Hf93Uqwxk5UFzbTKxV+Yy15UXMTeZ0FR2EZboiLt5wcsltpEvBo4bkjZU2COVAhfJk=
Message-ID: <a4e6962a0705081507u39ab95c6oee147ac3e453624a@mail.gmail.com>
Date: Tue, 8 May 2007 17:07:05 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [V9fs-developer] [PATCH 1/4] v9fs: rename non-vfs related structs and functions to be moved to net/9p
Cc: "Latchesar Ionkov" <lucho@ionkov.net>, linux-fsdevel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20070508141012.7fdf4c24.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f158dc670705081351j4d46b433o2bdd2e8212a52e15@mail.gmail.com>
	 <20070508141012.7fdf4c24.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 8 May 2007 14:51:02 -0600
> "Latchesar Ionkov" <lucho@ionkov.net> wrote:
>
> > This patchset moves non-filesystem interfaces of v9fs from fs/9p to net/9p.
> > It moves the transport, packet marshalling and connection layers to net/9p
> > leaving only the VFS related files in fs/9p.
>
> (Please cc netdev@vger.kernel.org on net-related work)
>
> These changes would be best handled via Eric's git tree, with appropriate
> acks from the net maintainers.
>

Ack.  I was waiting to see if Lucho hit any major brick walls with the
community before pulling them in.

                -eric
