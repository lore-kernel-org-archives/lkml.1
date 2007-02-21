Return-Path: <linux-kernel-owner+w=401wt.eu-S1422826AbXBUTXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422826AbXBUTXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422831AbXBUTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:23:04 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44258 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422826AbXBUTXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:23:01 -0500
Date: Wed, 21 Feb 2007 11:22:58 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/3] slab: introduce krealloc
In-Reply-To: <84144f020702211119ub028ccahee15629f02491840@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702211121540.25522@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI> 
 <Pine.LNX.4.64.0702210951580.24344@schroedinger.engr.sgi.com> 
 <45DC8DA1.6030100@cs.helsinki.fi>  <Pine.LNX.4.64.0702211023300.24719@schroedinger.engr.sgi.com>
  <45DC916E.1020300@cs.helsinki.fi>  <Pine.LNX.4.64.0702211041061.24941@schroedinger.engr.sgi.com>
 <84144f020702211119ub028ccahee15629f02491840@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pekka Enberg wrote:

> Well, as a reference, the user-space equivalent is defined in SUSv3 as:
> 
> "The realloc() function shall change the size of the memory object
> pointed to by ptr to the size specified by size."

The realloc functions intent is to leave the object in place if possible.
Otherwise one can simply alloc a new object and free the old one.
