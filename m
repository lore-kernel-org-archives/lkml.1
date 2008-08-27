Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYH0UCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYH0UCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYH0UCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:02:42 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:42916 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYH0UCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BxmyjEelF9iI3yRoGo2JJAwqRUdBcGvVGD2ZLJvbLuRiHUqz+C36mClAckS1DMQ+E9
         FdxORN3W0gl6qAtlVhOPHdKA7+8O0OGWl0vwNZD/QMX/Ny/M3++DD5tKJ83NSgOOW6/z
         QfVI3F9zqeCsTT/hcbqLp2ab/WreuUSxbOmhI=
Date: Thu, 28 Aug 2008 00:04:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080827200413.GA31324@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826220157.397C7154233@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. UTRACE_ATTACH_MATCH_DATA is not used.

2. s/utrace_attached_engine/utrace_engine/g

   Engine which is not attached is either just allocated or scheduled
   for freeing

3. get_utrace_lock() is funny.

   From name one should get valid struct utrace or -E depending only on
   task, why engine matters is a mystery.

4. subsys_initcall

   Just use module_init() or comment why it's needed.

5. Dummy in examiner -- not used (of course!)

