Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYJ3PkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYJ3PkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbYJ3PkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:40:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:53664 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYJ3PkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SpykFYfxDk+CSZrqu7e8kULeptvVMizP2mCoF4QUcFUE5wFrZ/ONxJD2kKvh8K/+rB
         MwPP7QpwR0F90ANL8ptGVAY3m6/hEY0W7+fljhBAXI+/qJ6CfMFolqKIDy1FfS95EmRA
         n0C5i6DUmTV2cLW62PYGqPXce78WMtFv+tBYc=
Message-ID: <9e4733910810300840v7cd45c2cu629d23a27a02c61a@mail.gmail.com>
Date: Thu, 30 Oct 2008 11:40:00 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jonas Bonn" <jonas.bonn@gmail.com>
Subject: Re: [RFC] API for system clocks (oscillators)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:41 AM, Jonas Bonn <jonas.bonn@gmail.com> wrote:
> I'd be happy to get some feedback on this, whether or not it is a good
> idea or even the right way to approach this problem.  This is part of
> the puzzle for solving the problem of frequency scaling on (primarily)
> embedded systems where there are many clocks, (changeable)
> relationships between clocks, device dependencies on clock
> availability, and device constraints on frequency that appear and
> disappear as devices are enabled and disabled.

How does this compare to the framework in linux/include/linux/clk.h?

-- 
Jon Smirl
jonsmirl@gmail.com
