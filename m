Return-Path: <linux-kernel-owner+w=401wt.eu-S1761919AbXHNOW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919AbXHNOW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXHNOWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:22:47 -0400
Received: from namei.org ([69.55.235.186]:33500 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753649AbXHNOWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:22:46 -0400
Date: Tue, 14 Aug 2007 07:22:31 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Avi Kivity <avi@argo.co.il>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hinoue@ccsl.carleton.ca,
       linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
In-Reply-To: <46C139BD.1030607@argo.co.il>
Message-ID: <Pine.LNX.4.64.0708140718130.32349@us.intercode.com.au>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
 <20070814000956.7c8929dd@the-village.bc.nu> <46C139BD.1030607@argo.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Avi Kivity wrote:

> Alan Cox wrote:
> > This is to protect it from being changed by an attacker or someone trying
> > to do strange and bogus things to the kernel.
> >   
> 
> Someone who apparently hasn't heard of vmap(), etc.
> 
> It's a debug aid at best.

It clarifies to all developers that the syscall table should not be messed 
with.


- James
-- 
James Morris
<jmorris@namei.org>
