Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZBESb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZBESb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZBESbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:31:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbZBESbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:31:48 -0500
Date: Thu, 5 Feb 2009 10:30:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@google.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: Re: [PATCH 2/2 v4] softlockup: check all tasks in hung_task
Message-Id: <20090205103050.6cd6365e.akpm@linux-foundation.org>
In-Reply-To: <20090205180749.GE9233@elte.hu>
References: <20090204194339.GB22608@elte.hu>
	<20090205043548.GA18933@google.com>
	<20090205143453.GG28443@elte.hu>
	<20090205094834.0dd9cfaa.akpm@linux-foundation.org>
	<20090205180749.GE9233@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 19:07:49 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> So i amended the commit in the way below - does that look good to you?
> 

yup.

> +#define HUNG_TASK_BATCHING 1024;

s/;//


