Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYLCRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYLCRU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYLCRUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:20:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44901 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYLCRUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:20:14 -0500
Date: Wed, 3 Dec 2008 11:22:01 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@br.ibm.com>
Subject: Re: [PATCH 1/6] integrity: TPM internel kernel interface
Message-ID: <20081203172201.GA17036@hallyn.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com> <1e02b363572908a21f67ff8abbf2b10190a4f6a6.1228253618.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e02b363572908a21f67ff8abbf2b10190a4f6a6.1228253618.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> This patch adds internal kernel support for:
>   - reading/extending a pcr value
>   - looking up the tpm_chip for a given chip number and type
> 
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Rajiv Andrade <srajiv@br.ibm.com>

(/me wonders why I can't seem to get any direct emails from you)

Dave's comments are good, and I'm sure you'll address them in a followup :),
but the basic chip lookup idiom (which as Dave says should be consolidated)
does look correct.

Acked-by: Serge Hallyn <serue@us.ibm.com>

-serge
