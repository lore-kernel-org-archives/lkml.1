Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbXEQSXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbXEQSXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXEQSXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:23:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbXEQSXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:23:23 -0400
Message-ID: <464C9D82.60105@redhat.com>
Date: Thu, 17 May 2007 14:22:58 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: righiandr@users.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC] log out-of-virtual-memory events
References: <464C81B5.8070101@users.sourceforge.net>
In-Reply-To: <464C81B5.8070101@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> I'm looking for a way to keep track of the processes that fail to allocate new
> virtual memory. What do you think about the following approach (untested)?

Looks like an easy way for users to spam syslogd over and
over and over again.

At the very least, shouldn't this be dependant on print_fatal_signals?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
