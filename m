Return-Path: <linux-kernel-owner+w=401wt.eu-S1765494AbXJRUB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765494AbXJRUB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXJRUBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:01:51 -0400
Received: from smtp102.sbc.mail.re2.yahoo.com ([68.142.229.103]:25405 "HELO
	smtp102.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757484AbXJRUBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:01:51 -0400
X-YMail-OSG: Yfe9uDQVM1lA7eHWA5RUsGrE0mE62eiP5quIxevPWtVVkoPMetOsn6YDa8S9n37vFT7YsXVruk9xiutnsbTLGGf8m_Jm5e8ShZ7n7ZLGshB1IJXh6sR4xTDvqMCyurmHJip_A8VT4bj7NLc-
Date: Thu, 18 Oct 2007 15:01:48 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, heiko.carstens@de.ibm.com, sam@ravnborg.org,
       schwidefsky@de.ibm.com
Subject: 2.6.23-mm1 s390 driver problem
Message-ID: <20071018200148.GA14234@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh, well this turned out less informative than I'd liked.
After bisecting 2.6.23 to 2.6.23-mm1, I found that
git-s390.patch is the one breaking my s390 boot :(
(Frown bc it's a conglomeration of patches0

Symptom is:
	"Cannot open root device "dasdd2" or unknown-block(94,14)"
even though dasdd2 appeared to be found earlier in the boot.  I also
get

Please append a correct "root=" boot option; here are the available partitions:
...
5e0c 7211520 dasdd driver: dasd-eckd
...
5e0e 6949296 dasdd2

Will keep looking at it, but maybe the fix is obvious to someone
in this cc: list?

thanks,
-serge
