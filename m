Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbYFRGNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbYFRGNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 02:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759038AbYFRGM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 02:12:58 -0400
Received: from ozlabs.org ([203.10.76.45]:35575 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbYFRGM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 02:12:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18520.42844.509290.191269@cargo.ozlabs.ibm.com>
Date: Wed, 18 Jun 2008 16:12:44 +1000
From: Paul Mackerras <paulus@samba.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Keep 3 high personality bytes across exec
In-Reply-To: <20080618060651.GA8251@us.ibm.com>
References: <20080618060651.GA8251@us.ibm.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric B Munson writes:

> Currently when a 32 bit process is exec'd on a powerpc 64 bit host the values
> of the top three bytes of the personality are clobbered.  This patch adds a
> check in the SET_PERSONALITY macro that will carry all the values in the top
> three bytes across the exec.
> 
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>

Your commit message needs to remind us what is in those bytes, and
tell us what bad things happen if we don't keep them, and what is the
benefit of keeping them.  And if there are any user-visible aspects of
this change, they need to be flagged.

Paul.
