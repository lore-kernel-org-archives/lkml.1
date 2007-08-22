Return-Path: <linux-kernel-owner+w=401wt.eu-S932322AbXHVQVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbXHVQVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764981AbXHVQV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:21:26 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40725 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765004AbXHVQVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:21:25 -0400
Message-ID: <46CC6150.6050105@vmware.com>
Date: Wed, 22 Aug 2007 09:16:16 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com> <46CBCC58.3010700@vmware.com> <46CBF5DD.6040300@qumranet.com>
In-Reply-To: <46CBF5DD.6040300@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> Since this is only for newer kernels, won't updating the driver to use 
> a hypercall be more efficient?  Or is this for existing out-of-tree 
> drivers?

Actually, it is for in-tree drivers that we emulate but don't want to 
pollute, and one out of tree driver (that will hopefully be in tree 
soon!) that has no way to determine if making hypercalls is acceptable.

Zach
