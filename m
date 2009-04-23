Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbZDWX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbZDWX0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbZDWX0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:26:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760701AbZDWX0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:26:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: mm_need_new_owner: use ->real_parent to search in
	the siblings
In-Reply-To: Oleg Nesterov's message of  Thursday, 23 April 2009 23:19:20 +0200 <20090423211920.GA22377@redhat.com>
References: <20090423211920.GA22377@redhat.com>
X-Shopping-List: (1) Proficient sand
   (2) Indulgent ardent piston snowbulbs
   (3) Continuous food
   (4) Scholastic pollution sauce
Message-Id: <20090423232513.E578CFC3C7@magilla.sf.frob.com>
Date: Thu, 23 Apr 2009 16:25:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

Note, I would also move "Search in the siblings" before "Search in the
children".  It should be the most common case.


Thanks,
Roland
