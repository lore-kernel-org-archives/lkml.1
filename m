Return-Path: <linux-kernel-owner+w=401wt.eu-S1763379AbYENTKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763379AbYENTKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYENTKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:10:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:57425 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYENTKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kqfoHLmqRbkxZKqjKwHeei3N0WN0e5FEx0Xq2q/K6TG6xN9NZWzRne6bm4Lg2Ot+d7ScDxm/cBh1uWxR0lsXBAKVae3iiR+vc0YDXbWI0l84IjkEh5JTDUbVf70GS/d14pYY50Hwl5G62swP5yQRhrUY1pw++SbM2elTMZZAhaA=
Date: Thu, 15 May 2008 00:05:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, davem@davemloft.net,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.26-rc2-mm1 - kernel panic at inet_create() on powerpc
Message-ID: <20080514200546.GA4802@martell.zuzino.mipt.ru>
References: <20080514010129.4f672378.akpm@linux-foundation.org> <482B066F.4010605@linux.vnet.ibm.com> <20080514160705.GB8812@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514160705.GB8812@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 09:07:05AM -0700, Paul E. McKenney wrote:
> On Wed, May 14, 2008 at 09:04:07PM +0530, Kamalesh Babulal wrote:
> > Hi Andrew,
> > 
> > 2.6.26-rc2-mm1 kernel panics on powerpc, while running ltp test over it.
> > I have attached the gdb output of the pc and lr registers. The patch
> > list_for_each_rcu-must-die-networking.patch points to changes made 
> > to the same lines listed by the gdb output.
> 
> Hmmm....  Does the panic go away when this patch is reverted?

Yes.

