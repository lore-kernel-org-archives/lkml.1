Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbXJAIBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbXJAIBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXJAIBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:01:09 -0400
Received: from sacred.ru ([62.205.161.221]:39725 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXJAIBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:01:08 -0400
Message-ID: <4700A7C5.5080005@openvz.org>
Date: Mon, 01 Oct 2007 11:54:45 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Cedric Le Goater <clg@fr.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] Move the user namespace under the option
References: <46FA7D4D.8040808@openvz.org> <46FA8087.6060307@openvz.org> <46FBA2A4.2040909@fr.ibm.com> <Pine.LNX.4.64.0709270837220.5275@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0709270837220.5275@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 01 Oct 2007 11:57:12 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Thu, 27 Sep 2007, Cedric Le Goater wrote:
> 
>>> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
>>> index b5f41d4..dda160c 100644
>>> --- a/include/linux/user_namespace.h
>>> +++ b/include/linux/user_namespace.h
>>> @@ -17,7 +17,7 @@ struct user_namespace {
>>>
>>>  extern struct user_namespace init_user_ns;
>>>
>>> -#ifdef CONFIG_USER_NS
>>> +#ifdef CONFIG_NAMESPACES_EXPERIMENTAL
> 
> is it really a good precedent to introduce Kconfig variables that
> literally include the word "EXPERIMENTAL"?

How else can we call it? I proposed one config option for
each namespace with "depends on EXPERIMENTAL" dependency,
but everyone else said that two options are much better.

> rday

