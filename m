Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYHLT35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYHLT35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYHLT3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:29:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYHLT3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:29:47 -0400
Date: Tue, 12 Aug 2008 15:29:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Dolding <oiaohm@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       serue@linux.vnet.ibm.com, Christoph Hellwig <hch@infradead.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20080812192925.GC18034@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221761.4444.13.camel@localhost.localdomain> <20080809185340.GC22905@infradead.org> <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com> <20080811170255.GA2662@us.ibm.com> <OFAC0E3107.C68382CD-ON852574A2.0068E1AD-852574A2.00692623@us.ibm.com> <20080811195645.GA16685@us.ibm.com> <e7d8f83e0808120141s4a0561fdw4919ce6f74d211af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7d8f83e0808120141s4a0561fdw4919ce6f74d211af@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 06:41:16PM +1000, Peter Dolding wrote:
> We really do need to get credentials patch in to common store all this
> permission/secuirty data..  With a section for integrity related
> entries.
> 
> Anti-Virus Passes and fails, signed running programs support and so on.
> 
> Lot of different things need ways of recording integrity status's.
> Users also need to know if a application does not work is it TPM is it
> Anti-virus is it lack of signature.

Peter, please read up what the credentials patches do, or how struct
cred/ucred is used in SVR4 and BSD for the last 20 years.  It is useful,
but it's not going to help with any of the strange thigns the AV or
Integrity people are doing.
