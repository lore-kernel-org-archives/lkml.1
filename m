Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYJGLP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYJGLP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYJGLPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:15:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbYJGLPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:15:13 -0400
Date: Tue, 7 Oct 2008 13:21:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007112119.GG20740@one.firstfloor.org>
References: <20081006132651.GG3180@one.firstfloor.org> <1223303879-5555-1-git-send-email-kirill@shutemov.name> <20081007195837.5A6B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007195837.5A6B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Honestly, I don't like that qemu specific feature insert into shmem core.

I wouldn't say it's a qemu specific interface.  While qemu would 
be the first user I would expect more in the future. It's a pretty
obvious extension. In fact it nearly should be default, if the
risk of breaking old applications wasn't too high.

-Andi

-- 
ak@linux.intel.com
