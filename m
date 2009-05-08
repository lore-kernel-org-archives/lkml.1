Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbZEHNyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbZEHNyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZEHNym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:54:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34671 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbZEHNym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:54:42 -0400
Message-ID: <4A04396B.2030800@redhat.com>
Date: Fri, 08 May 2009 09:53:47 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080915)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Eric Paris <eparis@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, serue@us.ibm.com, hpa@zytor.com,
       sukadev@us.ibm.com, linux-kernel@vger.kernel.org, jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for single	andmultiple-instancemounts
References: <20090307180816.GA30072@us.ibm.com> <20090307181232.GF30072@us.ibm.com> <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com> <20090507212429.GA24064@linux.vnet.ibm.com> <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com> <20090507231844.GA27609@linux.vnet.ibm.com> <20090507232110.GB27609@linux.vnet.ibm.com>
In-Reply-To: <20090507232110.GB27609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> | Must be the
> | 
> | 	memset(&opts, 0, sizeof(opts));
> | 
> | in devpts_get_sb() (first statement). It should probably set the options to
> | default values for cases where 'data' is NULL.
> | 
> | For now, can you try replacing the memset with:
>
> Er. I meant add following lines after the memset().
>
> |         opts->mode    = DEVPTS_DEFAULT_MODE;
> |         opts->ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;
> | 
> | Sukadev

With the obvious syntactic changes to account for opts being a
struct as opposed to being a pointer to a struct, these two lines
do seem to make things better.

       ps
