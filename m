Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZEGXVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZEGXVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbZEGXVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:21:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48072 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbZEGXVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:21:04 -0400
Date: Thu, 7 May 2009 16:21:10 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       serue@us.ibm.com, hpa@zytor.com, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org, jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for single
	andmultiple-instancemounts
Message-ID: <20090507232110.GB27609@linux.vnet.ibm.com>
References: <20090307180816.GA30072@us.ibm.com> <20090307181232.GF30072@us.ibm.com> <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com> <20090507212429.GA24064@linux.vnet.ibm.com> <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com> <20090507231844.GA27609@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507231844.GA27609@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| Must be the
| 
| 	memset(&opts, 0, sizeof(opts));
| 
| in devpts_get_sb() (first statement). It should probably set the options to
| default values for cases where 'data' is NULL.
| 
| For now, can you try replacing the memset with:

Er. I meant add following lines after the memset().

|         opts->mode    = DEVPTS_DEFAULT_MODE;
|         opts->ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;
| 
| Sukadev
