Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZCPD2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZCPD2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZCPD2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:28:23 -0400
Received: from mail-gx0-f165.google.com ([209.85.217.165]:59861 "EHLO
	mail-gx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZCPD2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:28:23 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Mar 2009 23:28:22 EDT
MIME-Version: 1.0
In-Reply-To: <1237170540-19130-16-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
	 <1237170540-19130-16-git-send-email-tj@kernel.org>
Date: Sun, 15 Mar 2009 21:23:02 -0600
Message-ID: <fa686aa40903152023q3a9a4d7fpcb7edeb1ac476b9@mail.gmail.com>
Subject: Re: [PATCH 15/17] block: kill end_request()
From: Grant Likely <grant.likely@secretlab.ca>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       =?ISO-8859-1?Q?J=F6rg_Dorchain?= <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
> Impact: kill obsolete interface function
>
> end_request() has been kept around for backward compatibility;
> however, it seems to be about time for it to go away.
[...]
> Cc: Grant Likely <grant.likely@secretlab.ca>

I've actually got a conflicting xsysace.c patch queued up.  To avoid
any problems, would it be okay by you if I roll the end_request
changes into my patch and repost it tomorrow?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
