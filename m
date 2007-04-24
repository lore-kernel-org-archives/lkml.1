Return-Path: <linux-kernel-owner+w=401wt.eu-S1030995AbXDXAmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030995AbXDXAmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030996AbXDXAmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:42:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47980 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030995AbXDXAms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:42:48 -0400
Date: Mon, 23 Apr 2007 17:42:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: <17965.20631.736307.24491@notabene.brown>
Message-ID: <Pine.LNX.4.64.0704231742310.1916@schroedinger.engr.sgi.com>
References: <17960.16739.870487.497750@notabene.brown>
 <Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
 <17960.20796.761309.771912@notabene.brown> <Pine.LNX.4.64.0704192236510.16503@schroedinger.engr.sgi.com>
 <17964.21972.961812.744601@notabene.brown> <Pine.LNX.4.64.0704231340180.512@schroedinger.engr.sgi.com>
 <17965.20631.736307.24491@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Neil Brown wrote:

> On Monday April 23, clameter@sgi.com wrote:
> > Would this work? Contains a solution somewhat along the lines of your 
> > thoughts on the subject.
> > 
> 
> Concept seems sound.
> Code needs a kfree of the name returned by create_unique_id, and I
> think ID_STR_LENGTH needs to be at least 34.

Sysfs copies the string?

