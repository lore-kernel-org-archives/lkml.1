Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYAGTSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYAGTSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYAGTSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:18:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:30069 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYAGTSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:18:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=k60v2HMTIj1Dj+rOArmyLRzDJmnrQGbYbtS0Yd5QuO/+FO1zhLm4wvGFUmDNqdxUmA4qMI/HrE4GewA/IW9LpFggfApswmOGw3VFk04/lIdRWWbhHqk59RzTgKAgyVWIx0+LSV3vvJ7/sZCYrWUoRboLBKcortmXu1WmospchKM=
Date: Mon, 7 Jan 2008 20:19:18 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 19/24] udf: check if udf_load_logicalvol failed
Message-ID: <20080107191904.GA22144@joi>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com> <1198374674-12128-20-git-send-email-marcin.slusarz@gmail.com> <20080107112951.GC12589@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080107112951.GC12589@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 12:29:51PM +0100, Jan Kara wrote:
> On Sun 23-12-07 02:51:09, marcin.slusarz@gmail.com wrote:
> > udf_load_logicalvol may fail eg in out of memory conditions - check it
> > and propagate error further
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> > CC: Jan Kara <jack@suse.cz>
>   I certainly agree with the idea of the change. Just note that
> udf_process_sequence() returns 1 in case of failure so propagating an error
> is not ideal - we should keep things consistent. And also note that the
> actual value is disregarded in udf_load_partition() anyway.
OK, I will make it consistent in next version.

Marcin
