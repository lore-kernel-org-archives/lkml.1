Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZJUHhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZJUHhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 03:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZJUHhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 03:37:11 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:50692 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751508AbZJUHhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 03:37:10 -0400
Date: Wed, 21 Oct 2009 02:44:14 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
In-Reply-To: <alpine.DEB.1.00.0910201439200.539@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0910210243510.9745@gentwo.org>
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com> <alpine.DEB.1.10.0910161249100.6120@gentwo.org> <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com> <alpine.DEB.1.10.0910162126090.26081@gentwo.org>
 <alpine.DEB.1.00.0910170154580.31277@chino.kir.corp.google.com> <alpine.DEB.1.10.0910171637180.28063@gentwo.org> <alpine.DEB.1.00.0910201439200.539@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009, David Rientjes wrote:

> Ok, once the stat files are moved to their own directory, I'll make a note
> to add a writable `clear' file that will do
>
> 	for (i = 0; i < NR_SLUB_STAT_ITEMS; i++)
> 		clear_stat(s, i);

Ok. Great. You are going to move the stats files with a patch?

