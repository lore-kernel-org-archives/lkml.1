Return-Path: <linux-kernel-owner+w=401wt.eu-S1764335AbYJJVg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764335AbYJJVg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYJJVgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:36:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:3598 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278AbYJJVgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NsHY3zFub2BZLc/k8VQaor7Ltb2MTT//0VJfdJG3XaJFY1IcuZUCDLAX6NNeaBGEA+
         L5rXplx0BIIuqn9c7v45bkrziGflomMr3lZSYmErehFMqMfo1p09h9N0iJTOaV2pEzNA
         x4x7ezlxFCFc/BpZoGzXkRBa8+8vq20ErDSZ8=
Message-ID: <a4e6962a0810101436l1297c28ewd1691f4ac7ddf412@mail.gmail.com>
Date: Fri, 10 Oct 2008 16:36:17 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Tom Tucker" <tom@opengridcomputing.com>
Subject: Re: [PATCH v2a] 9prdma: RDMA Transport Support for 9P
Cc: rdrier@cisco.com, linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org,
       rminnich@dancer.ca.sandia.gov, lionkov@lanl.gov
In-Reply-To: <1223388592-27719-1-git-send-email-tom@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223388592-27719-1-git-send-email-tom@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/08, Tom Tucker <tom@opengridcomputing.com> wrote:
> (in cq_comp_handler)
>  +               struct p9_rdma_context *c = (void *)wc.wr_id;
...
>  +static int
>  +post_recv(struct p9_trans *trans, struct p9_rdma_context *c)
>  +       wr.wr_id = (u64)c;
...

Ouch.  I get warnings on these two compiling on 32-bit systems.

I'm almost finished with a patch to your patch which fits it into the
new organizational structure and API.  I'll try to send it by the end
of the day.  I don't currently have an Infiniband test setup, so I'm
only going to be able to check that it builds....

         -eric
