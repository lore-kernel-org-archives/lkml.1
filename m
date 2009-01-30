Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbZA3JF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbZA3JF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZA3JFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:05:06 -0500
Received: from mail.crca.org.au ([67.207.131.56]:53658 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbZA3JFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:05:04 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: marching through all physical memory in software
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: Pavel Machek <pavel@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Doug Thompson <norsk5@yahoo.com>, linux-mm@kvack.org,
       bluesmoke-devel@lists.sourceforge.net
In-Reply-To: <20090128193813.GD1222@ucw.cz>
References: <497DD8E5.1040305@nortel.com>
	 <20090126075957.69b64a2e@infradead.org> <497F5289.404@nortel.com>
	 <m1vds0bj2j.fsf@fess.ebiederm.org>  <20090128193813.GD1222@ucw.cz>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 20:05:24 +1100
Message-Id: <1233306324.11332.11.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2009-01-28 at 20:38 +0100, Pavel Machek wrote:
> You can do the scrubbing today by echo reboot > /sys/power/disk; echo
> disk > /sys/power/state :-)... or using uswsusp APIs.

That won't work. The RAM retains it's contents across a reboot, and even
for a little while after powering off.

Regards,

Nigel

