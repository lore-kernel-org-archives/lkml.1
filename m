Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZFAWyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZFAWyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZFAWy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:54:26 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:51782 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZFAWyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UtZDDFex8L+fJ5gcD0cLs+0IQhZ8rCSpbyLUoDZSE9xm/ma4fpE1V6zZMQFb0a8F2V
         Ud6eq8ilFlm1I3KLza11BqiAlPqTT6UGro9f2TaFbDmS8Di1+orFcOoEdRIAB7iQHvdy
         kWf/3O27GH5M79Yfh2PwM8c8EdlhRTld5ts5Y=
MIME-Version: 1.0
In-Reply-To: <1243121915-10775-1-git-send-email-vapier@gentoo.org>
References: <1243121915-10775-1-git-send-email-vapier@gentoo.org>
Date: Mon, 1 Jun 2009 18:54:27 -0400
Message-ID: <8bd0f97a0906011554l54216e73v6fe9eb54a0eadb80@mail.gmail.com>
Subject: Re: [PATCH] fix detection of CONFIG_FRAME_WARN=0
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 19:38, Mike Frysinger wrote:
> The checking of CONFIG_FRAME_WARN in the top level Makefile forgot to
> actually derefence the variable thus leading to an always true check.

Andrew: could you pick this up ?
-mike
