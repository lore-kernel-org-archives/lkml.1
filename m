Return-Path: <linux-kernel-owner+w=401wt.eu-S933781AbXGRQXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbXGRQXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXGRQXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:23:14 -0400
Received: from [192.102.209.1] ([192.102.209.1]:45014 "EHLO
	laptopd505.fenrus.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756508AbXGRQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:23:13 -0400
X-Greylist: delayed 3083 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 12:23:12 EDT
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
From: Arjan van de Ven <arjan@linux.intel.com>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <Line.LNX.4.64.0707141233490.26711@d.namei>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 18 Jul 2007 08:28:12 -0700
Message-Id: <1184772492.2688.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 12:37 -0400, James Morris wrote:
> Convert LSM into a static interface, as the ability to unload a security
> module is not required by in-tree users and potentially complicates the
> overall security architecture.
> 
> Needlessly exported LSM symbols have been unexported, to help reduce API
> abuse.
> 
> Parameters for the capability and root_plug modules are now specified
> at boot.
> 
> The SECURITY_FRAMEWORK_VERSION macro has also been removed.
> 
> Signed-off-by: James Morris <jmorris@namei.org>


This is a good cleanup since modular LSM modules just aren't working,
and prepares for the option of removing the runtime overhead of LSM
altogether for selected configs... that is going to be a big step
forward to make SELinux and any other model be more acceptable for
people who care about performance.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
