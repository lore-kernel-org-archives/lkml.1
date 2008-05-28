Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbYE1NNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbYE1NNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYE1NNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:13:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYE1NNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:13:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0805221909050.4056@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0805221909050.4056@sbz-30.cs.Helsinki.FI>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: dhowells@redhat.com, clameter@sgi.com, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] nommu: fix ksize() abuse
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 May 2008 14:12:48 +0100
Message-ID: <2888.1211980368@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The nommu binfmt code uses ksize() for pointers returned from do_mmap() 
> which is wrong. This converts the call-sites to use the nommu specific 
> kobjsize() function which works as expected.
> 
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: David Howells <dhowells@redhat.com>
