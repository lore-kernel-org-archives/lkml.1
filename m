Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZKCBXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZKCBXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbZKCBXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:23:33 -0500
Received: from smtp-out.google.com ([216.239.45.13]:9389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbZKCBXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:23:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=Bn/de4UDr6A7yFgxrDSqtL6xDsWUkhqPnWS/da+n77DE4vgmUKdapQfDkLaq9CdKk
	bn1pWyhFg7r3C6+J85PIw==
MIME-Version: 1.0
In-Reply-To: <b741c2440911021721o610ee4f1la123146e6e503d2d@mail.gmail.com>
References: <b741c2440911012346k7213befcida229606f10c0399@mail.gmail.com>
	 <4AEF81E2.3060403@cn.fujitsu.com>
	 <b741c2440911021721o610ee4f1la123146e6e503d2d@mail.gmail.com>
Date: Mon, 2 Nov 2009 17:23:31 -0800
Message-ID: <6599ad830911021723t77583792q1a22c345d3b0d3c1@mail.gmail.com>
Subject: Re: [PATCH 2/3] Fix the 'current css_set' problem in debug subsystem
From: Paul Menage <menage@google.com>
To: Liu Aleaxander <aleaxander@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 5:21 PM, Liu Aleaxander <aleaxander@gmail.com> wrote:
> Yes, I know it means 'current task', but is this useful to print the
> same things with two more files in all the cgroups?
>

We could just export those files in the root cgroup in the debug hierarchy.

Paul
