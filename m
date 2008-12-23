Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYLWQve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYLWQve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYLWQvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:51:24 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38466 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYLWQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:51:24 -0500
Date: Tue, 23 Dec 2008 10:51:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: Re: [RFC][PATCH 0/6][v3] Container-init signal semantics
Message-ID: <20081223165121.GA18031@us.ibm.com>
References: <20081221005106.GA4912@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221005106.GA4912@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> 
> Container-init must behave like global-init to processes within the
> container and hence it must be immune to unhandled fatal signals from
> within the container (i.e SIG_DFL signals that terminate the process).
> 
> But the same container-init must behave like a normal process to 
> processes in ancestor namespaces and so if it receives the same fatal
> signal from a process in ancestor namespace, the signal must be
> processed.
> 
> Implementing these semantics requires that send_signal() determine pid
> namespace of the sender but since signals can originate from workqueues/
> interrupt-handlers, determining pid namespace of sender may not always
> be possible or safe.

Tested-by: Serge Hallyn <serue@us.ibm.com>

Tested sending signals to a custom container-init.

Are you planning to address Oleg's comments with a new patch-set,
or with patches on top of this set?

thanks,
-serge
