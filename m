Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbZJJMSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbZJJMSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 08:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758916AbZJJMSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 08:18:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57418 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643AbZJJMSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 08:18:06 -0400
Date: Sat, 10 Oct 2009 14:17:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Hibernate: fix error handling in save_image
Message-ID: <20091010121723.GC1943@ucw.cz>
References: <1255175505-7756-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255175505-7756-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-10-10 13:51:45, Jiri Slaby wrote:
> There are too many retval variables in save_image. Thus error return
> value from snapshot_read_next may be ignored and only part of the
> snapshot (successfully) written.
> 
> Remove 'error' variable, invert the condition in the do-while loop
> and convert the loop to use only 'ret' variable.
> 
> Switch the rest of the function to consider only 'ret'.
> 
> Also make sure we end printed line by \n if an error occurs.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
