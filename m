Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYIJRp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYIJRp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYIJRpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:45:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54301 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbYIJRpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:45:31 -0400
Subject: Re: [RFC v4][PATCH 4/9] Memory management (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <1221065728.6781.19.camel@nimitz>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu>
	 <1221065728.6781.19.camel@nimitz>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 10:45:23 -0700
Message-Id: <1221068723.6781.21.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 09:55 -0700, Dave Hansen wrote:
> 
> > +               cond_resched();
> > +               while (!(page = follow_page(vma, addr, FOLL_TOUCH))) 

Why is the FOLL_TOUCH required here?

-- Dave

