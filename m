Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbXJCWnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbXJCWnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 18:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXJCWnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 18:43:01 -0400
Received: from namei.org ([69.55.235.186]:41499 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752250AbXJCWnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 18:43:00 -0400
Date: Wed, 3 Oct 2007 15:42:32 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <morgan@kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2 -mm] capabilities: define CONFIG_COMMONCAP
In-Reply-To: <20071003222746.GA1562@sergelap.austin.ibm.com>
Message-ID: <Xine.LNX.4.64.0710031539190.629@us.intercode.com.au>
References: <20071003222746.GA1562@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007, Serge E. Hallyn wrote:

> >From 54c70ca7671750fe8986451fae91d42107d0ca90 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Fri, 28 Sep 2007 10:33:33 -0500
> Subject: [PATCH 1/2 -mm] capabilities: define CONFIG_COMMONCAP
> 
> currently the compilation of commoncap.c is determined
> through Makefile logic.  So there is no single CONFIG
> variable which can be relied upon to know whether it
> will be compiled.
> 
> Define CONFIG_COMMONCAP to be true when lsm is not
> compiled in, or when the capability or rootplug modules
> are compiled.  These are the cases when commoncap is
> currently compiled.  Use this variable in security/Makefile
> to determine commoncap.c's compilation.
> 
> Apart from being a logic cleanup, this is needed by the
> upcoming cap_bset patch so that prctl can know whether
> PR_SET_BSET should be allowed.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
