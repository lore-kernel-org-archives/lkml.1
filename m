Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbXISX2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbXISX2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXISX2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:28:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbXISX2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:28:36 -0400
Message-ID: <46F1B097.9020109@redhat.com>
Date: Wed, 19 Sep 2007 19:28:23 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: 2.6.23-rc6-mm1
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	<46F1AA6E.1030708@imap.cc> <20070919162438.7264f06c.akpm@linux-foundation.org>
In-Reply-To: <20070919162438.7264f06c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2007 07:24 PM, Andrew Morton wrote:
> 
> Nah, that's an rtc-specific problem.
> 
> I think David says that it's actually not a problem, but I didn't
> really understand how this can be?
> 
> Perhaps I'll need to drop that debugging patch.  Which would be a shame,
> because it can detect real bugs.  Perhaps it needs a strcmp("rtc") to
> filter out the (surprising) false positive.

AFAICT the rtc problem is caused by misconfiguration: both the new
and old rtc driver have been built and they are both trying to load.
