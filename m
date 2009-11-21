Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbZKUINQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbZKUINQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 03:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZKUINP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 03:13:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54966 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZKUINO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 03:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=KWMdFO42q4cmma8vmIbOxOoCe4OsbFw6YFgoRmMcfp/OvA8+Rs5OkjXRi/cJshoXr7
         wj7LKqZkNWLgdiywhJK3FKcrlnLiQj4Uhh6QT0uPjxlRqzjq+BNqUscoatLAfXQzeLrC
         WjJdVVyl8nAp/yJlS85T+wHnkXjuRVNlr/HX8=
Date: Sat, 21 Nov 2009 10:13:01 +0200
From: Dan Carpenter <error27@gmail.com>
To: Dan Carpenter <error27.lkml@gmail.com>
Cc: Rakesh Ranjan <rakesh@chelsio.com>, David Miller <davem@davemloft.net>,
       michaelc@cs.wisc.edu, open-iscsi@googlegroups.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@suse.de, kxie@chelsio.com
Subject: Re: [RFC-PATCH] libiscsi dhcp handler
Message-ID: <20091121081301.GA17766@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dan Carpenter <error27.lkml@gmail.com>,
	Rakesh Ranjan <rakesh@chelsio.com>,
	David Miller <davem@davemloft.net>, michaelc@cs.wisc.edu,
	open-iscsi@googlegroups.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
	kxie@chelsio.com
References: <4B014F95.8000906@chelsio.com> <20091116.051835.125328285.davem@davemloft.net> <4B01577E.2020003@chelsio.com> <b263e5900911200529n1c002097q48a625d1bcda4db6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b263e5900911200529n1c002097q48a625d1bcda4db6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 03:29:24PM +0200, Dan Carpenter wrote:
> On 11/16/09, Rakesh Ranjan <rakesh@chelsio.com> wrote:
> > David Miller wrote:
> >> From: Rakesh Ranjan <rakesh@chelsio.com>
> >> Date: Mon, 16 Nov 2009 18:41:49 +0530
> >>
> >>> Herein attached patches to support dhcp based provisioning for iSCSI
> >>> offload capable cards. I have made dhcp code as generic as possible,
> >>> please go through the code. Based on the feedback I will submit final
> >>> version of these patches.
> >>
> >> You can't really add objects to the build before the patch that
> >> adds the source for that object.
> >>
> >
> > Hi david,
> >
> > Fixed patch attached.

+       spin_unlock(&rcv_lock);                                                                                              
+                                                                                                                            
+drop:                                                                                                                       
+       kfree(pskb);                                                                                                         

This should be kfree_skb(pskb)

+out:                                                                                                                        
+       return rc;                                                                                                           
+}                                                                                                                           
+EXPORT_SYMBOL(libiscsi_ipconfig_recv);                                                                                      

regards,
dan carpenter
