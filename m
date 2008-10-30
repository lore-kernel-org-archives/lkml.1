Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYJ3OJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYJ3OJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYJ3OIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:08:55 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52142 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbYJ3OIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:08:55 -0400
Date: Thu, 30 Oct 2008 09:08:43 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Louis Rilling <Louis.Rilling@kerlabs.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based
	checkpointing/restart
Message-ID: <20081030140843.GA5600@us.ibm.com>
References: <1220439476-16465-1-git-send-email-major@openvz.org> <200810271707.13580.major@openvz.org> <4905D2AD.1070309@cs.columbia.edu> <200810300902.47067.major@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810300902.47067.major@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrey Mirkin (major@openvz.org):
> Anyway we should ask everyone what they think about user- and kernel- based 
> process creation.
> Dave, Serge, Cedric, Daniel, Louis what do you think about that?

I prefer kernel.  Pretty sure Dave prefers user-space.

I'd say the thing to do is push the core API that supports single-thread
c/r.  Then try to push the patch to do recreate processes from the
kernel, and let the arguments for and against that stand on their own.

-serge
