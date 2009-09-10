Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZIJXQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZIJXQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZIJXQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:16:42 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:51185 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZIJXQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:16:41 -0400
Message-ID: <4AA988B2.4060102@nortel.com>
Date: Thu, 10 Sep 2009 17:16:02 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Brian McGrew <brian@visionpro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: mmap vs. real memory
References: <C6CECDE3.13A4A%brian@visionpro.com>
In-Reply-To: <C6CECDE3.13A4A%brian@visionpro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Sep 2009 23:16:41.0791 (UTC) FILETIME=[C182C4F0:01CA326C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 04:38 PM, Brian McGrew wrote:

> Now that we are needing more and more shared memory, we're seeing random
> performance issues.  With 16MB, 64MB and 256MB (in recent past) all was
> good.  But now, trying to allocate 1GB of shared memory, we see it taking
> anywhere from .6 to 9 SEONDS to access the file.  No good!
> 
> What I'm wondering and needed to do is map a chunk of mymoery (1GB today,
> maybe 2GB later on) so that all my apps can access it.  Short of creating a
> ramdisk and moving the mmap'ed file to ramdisk, what is the best way to do
> this???

Maybe make a ramfs partition, mount it somewhere, and create your file
there?  This is more efficient and simpler than creating a ramdisk.

Alternately, have you considered using hugetlbfs and mapping the shared
memory with large pages?

Chris
