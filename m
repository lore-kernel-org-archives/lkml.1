Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbZHNGHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbZHNGHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 02:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZHNGHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 02:07:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:35998 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbZHNGHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 02:07:12 -0400
Date: Fri, 14 Aug 2009 16:06:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Xiaotian Feng <dfeng@redhat.com>
cc: eparis@parisplace.org, sds@tycho.nsa.gov, paul.moore@hp.com,
       serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] selinux: fix memory leak in sel_make_bools
In-Reply-To: <1250215360-20871-1-git-send-email-dfeng@redhat.com>
Message-ID: <alpine.LRH.2.00.0908141606290.12770@tundra.namei.org>
References: <1250151976-19399-1-git-send-email-dfeng@redhat.com> <1250215360-20871-1-git-send-email-dfeng@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Xiaotian Feng wrote:

> In sel_make_bools, kernel allocates memory for bool_pending_names[i]
> with security_get_bools. So if we just free bool_pending_names, those
> memories for bool_pending_names[i] will be leaked.

Thanks, applied and pushed to Linus.

-- 
James Morris
<jmorris@namei.org>
