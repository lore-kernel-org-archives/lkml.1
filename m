Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZI3WdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZI3WdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZI3WdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:33:00 -0400
Received: from tundra.namei.org ([65.99.196.166]:34892 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbZI3WdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:33:00 -0400
Date: Thu, 1 Oct 2009 08:32:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] TPM: fix pcrread
In-Reply-To: <1254342429.3544.20.camel@dyn9002018117.watson.ibm.com>
Message-ID: <alpine.LRH.2.00.0910010832370.30576@tundra.namei.org>
References: <1254324415.13475.24.camel@blackbox> <1254342429.3544.20.camel@dyn9002018117.watson.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009, Mimi Zohar wrote:

> On Wed, 2009-09-30 at 12:26 -0300, Rajiv Andrade wrote:
> > +	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
> >  			  "attempting to read a pcr value");
> > 
> >  	if (rc == 0)
> 
> Compiled and tested patch.
> 
> Acked-by: Mimi Zohar <zohar@us.ibm.com>

Thanks.



Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris <jmorris@namei.org>
