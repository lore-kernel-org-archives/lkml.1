Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbXFGQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbXFGQMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXFGQMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:12:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXFGQMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:12:46 -0400
Message-ID: <46682E4E.1070303@redhat.com>
Date: Thu, 07 Jun 2007 12:11:58 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Lord <lkml@rtr.ca>, Stephen Tweedie <sct@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org>
In-Reply-To: <20070607084142.42583639.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2007 11:41 AM, Andrew Morton wrote:
>>    mount /var/lib/mythtv -oremount,ro
>>    sync
>>    umount /var/lib/mythtv
> 
> Did this succeed?  If the application is still truncating that file, the
> umount should have failed.

Shouldn't sync should wait for truncate to finish?
