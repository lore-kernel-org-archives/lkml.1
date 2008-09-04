Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYIDWzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYIDWzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 18:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYIDWzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 18:55:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55425 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbYIDWza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 18:55:30 -0400
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based
	checkpointing/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: devel@openvz.org, containers@lists.linux-foundation.org,
       Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200809031759.29132.major@openvz.org>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
	 <48BE82F9.4020808@fr.ibm.com>  <200809031759.29132.major@openvz.org>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 15:55:26 -0700
Message-Id: <1220568926.23386.70.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 17:59 +0400, Andrey Mirkin wrote:
> > The first issues I see with this direction are some EXPORT_SYMBOL() that
> > would be useless without a module.
> 
> Checkpoint/restart functionality is implemented as a kernel module to provide 
> more flexibility during development process - you can easily unload module, 
> fix what you need and load module again, you do not need to reboot you server 
> in this case. We have discussed this question during Container's mini summit 
> on OLS-2008 and we have found out that it will be convenient to have such an 
> ability.

It would probably be best to separate out the bits that are needed to
make this feature build as a module.  Since, as you say, this is only
useful during development, we'll have to rip these bits out eventually
to get it merged.  Might as well do that from the start.  

-- Dave

