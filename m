Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbYHFUW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbYHFUW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbYHFUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:22:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36745 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758315AbYHFUWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:22:43 -0400
Date: Wed, 6 Aug 2008 15:22:41 -0500
From: Paul Jackson <pj@sgi.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset.c : Removes extra variable
Message-Id: <20080806152241.387e765d.pj@sgi.com>
In-Reply-To: <b9df5fa10808060550y483d1c1dh99bac10c158510df@mail.gmail.com>
References: <b9df5fa10808060550y483d1c1dh99bac10c158510df@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rabik wrote:
> removes ... cpus_nonempty variable

No.

Sorry - I must NAQ this patch.  I intentionally add inessential
variables such as this in order to make the code easier to read.

I consider the line of code:

	if (cpus_nonempty && balance_flag_changed)

to be more readable than the line of clde:

	if (!cpus_empty(trialcs.cpus_allowed) && balance_flag_changed)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
