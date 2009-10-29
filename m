Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbZJ2MGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbZJ2MGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 08:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZJ2MGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 08:06:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:55003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZJ2MGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 08:06:14 -0400
Message-ID: <4AE9855C.50709@kernel.org>
Date: Thu, 29 Oct 2009 13:06:52 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       rostedt@goodmis.org, hpa@zytor.com, cebbert@redhat.com,
       tony.luck@intel.com
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <4AD6EA57.6020105@kernel.org> <4ADC6C67.8090206@monstr.eu>
In-Reply-To: <4ADC6C67.8090206@monstr.eu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> If I understand correctly, functionality will be the same. But
> anyway I would like to mot lose information about per_cpu
> variables. That's why please keep that macro for Microblaze. If is
> the problem, you should convince me why to do it.

It's not a problem at all.  The only thing is that now there's nothing
which enforces usage of that macro in assemblies.  If someone forgets
to use that macro, it will work all the same.  It would be great if we
can fix it somehow but I don't have much idea ATM.  Anyways, for now,
I'll proceed in the current form.

Thanks.

-- 
tejun
