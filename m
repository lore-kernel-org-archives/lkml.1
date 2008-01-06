Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbYAFRLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbYAFRLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbYAFRLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:11:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47035 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170AbYAFRLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:11:04 -0500
Date: Sun, 6 Jan 2008 09:10:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
Subject: Re: [patch 1/5] Introduce __WARN()
Message-ID: <20080106091031.420c355d@laptopd505.fenrus.org>
In-Reply-To: <4780FD48.4030505@student.ltu.se>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
	<20080105190840.48a8c2c5@laptopd505.fenrus.org>
	<4780BF38.3010902@student.ltu.se>
	<20080106074202.3c25b115@laptopd505.fenrus.org>
	<4780FD48.4030505@student.ltu.se>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jan 2008 17:09:44 +0100
Richard Knutsson <ricknu-0@student.ltu.se> wrote:

> >> (btw, wouldn't 'var != 0' actually be the proper semantic instead
> >> of playing with '!'s?)
> >>     
> >
> > no because var could be a pointer for example...
> >   
> You mean because in that case it would be '!= NULL', do you? Sorry,
> do not see your point here.

my point is that you don't know which one to use.. 
But this isn't new discussion (nor something I'm changing at all); this has come
up since way back in 2005 :)
If you feel strongly of changing this, feel free to post a patch; for now I much
rather leave things as they are right now.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
