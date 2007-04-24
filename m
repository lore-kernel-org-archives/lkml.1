Return-Path: <linux-kernel-owner+w=401wt.eu-S1031029AbXDXCTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031029AbXDXCTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031033AbXDXCTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:19:48 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:40323 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031029AbXDXCTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oXS0bGNFdekyeSqltkUyXBFzAsOQ9YrUVhrHzA5W8lBl0x9s3+z4PPMvGz45B0IigrS4xh6WLzBXmWA7c80H1dXxWJeSLzp4TKZ/RVJ7Zwcm3dsb86nSN6ZhacUeSYDUjdn9nM4SpF7XJqjHG0HfkbWbyPHFS/80XYS+0FckxpQ=
Message-ID: <a781481a0704231919s584e55bfv99f45132b6f191c@mail.gmail.com>
Date: Tue, 24 Apr 2007 07:49:45 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: Remove open coded implementations of memclear_highpage flush
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0704231547080.975@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704231547080.975@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, Christoph Lameter <clameter@sgi.com> wrote:
> There are a series of open coded reimplementation of memclear_highpage_flush
> all over the page cache code. Call memclear_highpage_flush in those locations.
> Consolidates code and eases maintenance.

If I remember right, a very similar patchset was recently submitted
that Andrew merged in -mm(?). It also renamed memclear_highpage_flush
to something like zero_user_page (though I wonder how good a name that
is considering it takes an offset and not the whole page) and
deprecated the old name.
