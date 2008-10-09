Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYJIQu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYJIQu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYJIQus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:50:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47215 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbYJIQur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:50:47 -0400
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oren Laadan <orenl@cs.columbia.edu>, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081009134415.GA12135@elte.hu>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>
	 <20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz>
	 <20081009131701.GA21112@elte.hu> <1223559246.11830.23.camel@nimitz>
	 <20081009134415.GA12135@elte.hu>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 09:50:36 -0700
Message-Id: <1223571036.11830.32.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 15:44 +0200, Ingo Molnar wrote:
> there might be races as well, especially with proxy state - and 
> current->flags updates are not serialized.
> 
> So maybe it should be a completely separate flag after all? Stick it 
> into the end of task_struct perhaps.

What do you mean by proxy state?  nsproxy?

-- Dave

