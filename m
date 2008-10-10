Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYJJFj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYJJFj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYJJFju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:39:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:38605 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYJJFju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u/74pa8FXQPeFt/9ZIKcmcq2eJW0yfSfE5wTAJiyGuN2juZ7c0mz4irkk2bnQb3fr7
         GN+W/u76qGQrmZyl5jNkHl4RQ83xUJhLqSThQMwiZfd3Rwg3ktCIjNuOq48sS4JYQh9O
         aTfvCKGumtE3nzXL8QnFWFJJa0RdsBUj/aMf4=
Subject: Re: [PATCH 3/4] xtensa: Change unaligned access to use packed
 struct implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Bob Wilson <bwilson@tensilica.com>
In-Reply-To: <48EEE546.9070405@zankel.net>
References: <1223447904.8195.67.camel@brick>  <48EEE546.9070405@zankel.net>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 22:39:47 -0700
Message-Id: <1223617187.8991.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 22:16 -0700, Chris Zankel wrote:
> Hi Harvey,
> 
> Please allow me a couple of days to look into it. I don't know the 
> historic reasons why the memmove variant was chosen.
> 
> Thanks,
> -Chris
> 

Sure, from the comments in the original version, it looks like it was done
this way to avoid __builtin_memcpy from being generated.  But maybe there was another
reason?

Harvey



