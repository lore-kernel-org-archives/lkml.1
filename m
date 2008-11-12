Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbYKLQt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbYKLQt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYKLQts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:49:48 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33085 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYKLQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:49:48 -0500
Date: Wed, 12 Nov 2008 10:49:15 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: sukadev@linux.vnet.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, daniel@hozac.com,
       Nadia Derbey <Nadia.Derbey@bull.net>, clg@fr.ibm.com,
       Containers <containers@lists.osdl.org>, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Signals to cinit
Message-ID: <20081112164915.GB14572@us.ibm.com>
References: <20081101180505.GA24268@us.ibm.com> <20081110173839.GA11121@redhat.com> <20081110193228.GA15519@redhat.com> <20081110232735.GA20891@us.ibm.com> <20081112145226.GA13269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112145226.GA13269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> > | Perhaps we can start with something like the patch below. Not that I like
> > | it very much though. We should really place this code under
> > | CONFIG_I_DO_CARE_ABOUT_NAMESPACES ;)
> >
> > CONFIG_PID_NS ?
> 
> Ah yes, we have it ;)

Except I believe all distros at this point enable CONFIG_PID_NS, so
I'm not sure it's the right thing to use.

-serge
