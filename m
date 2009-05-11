Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbZEKXAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbZEKXAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760887AbZEKXA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:00:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:23674 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760324AbZEKXAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rK3+RCzyP8JdDxBZ8ltenitqEf4302tCOCqcxnCPbycmaa6DXDP6Eyz1BE6OgAAd5c
         R3uB3xNPj61mYXqGbQtbx1Vop15ty3rmO3D6ofxRQ7wmJEG0yrwQqrPin/I+eAt459DX
         TcWoH+TJWFP7ZKQq/0SBZXmaSrGJduXXZB774=
MIME-Version: 1.0
In-Reply-To: <20090511221502.GA32530@linux.vnet.ibm.com>
References: <20090307180816.GA30072@us.ibm.com>
	 <20090307181232.GF30072@us.ibm.com>
	 <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com>
	 <20090507212429.GA24064@linux.vnet.ibm.com>
	 <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com>
	 <20090507231844.GA27609@linux.vnet.ibm.com>
	 <20090507232110.GB27609@linux.vnet.ibm.com>
	 <4A04F5D7.2050909@gmail.com>
	 <20090511221502.GA32530@linux.vnet.ibm.com>
Date: Mon, 11 May 2009 19:00:25 -0400
Message-ID: <6041d2000905111600y648b5b02gcea3d133a749d686@mail.gmail.com>
Subject: Re: [v3][PATCH 5/5] Merge code for single andmultiple-instancemounts
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, serue@us.ibm.com, hpa@zytor.com,
       sukadev@us.ibm.com, linux-kernel@vger.kernel.org, jbacik@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 6:15 PM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
> Here is a cleaner fix - When user space (/etc/rc.sysinit on RHEL5) mounts
> devpts, this problem might be masked since the mount system call could pass
> a non-NULL 'data' parmeter to devpts_get_sb().
>
> I tested this patch by directly calling the system call mount() with a NULL
> data parameter. If you/Eric/Peter can confirm that this works for you, I will
> send this patch to Andrew.
>
> Thanks,

Works fine here, thanks.

Marc
