Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZBSCad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZBSCad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 21:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZBSCaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 21:30:24 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:62363 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbZBSCaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 21:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HBoTH3YaUyfnfO53jCXEcnefgYW7Tz1QXVEQE+YYvANWmtCOaSVNrQvk0AEfYBB/mQ
         FWZCSl0m6kMZFtyv3525YIA7kHMq1A/NejUYvVLUigC8XAiwNkPrqp//wBHxHjE48syY
         nJn24+lgDxp7eGjiTyTMCzl39J+ogyWazVgl8=
Message-ID: <499CC43C.3000406@gmail.com>
Date: Wed, 18 Feb 2009 20:30:20 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Scott Simpson <simpson100@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How do you profile an executable that loads shared libraries?
References: <79759ec90902181549t292d1adco55416c04366afdad@mail.gmail.com>
In-Reply-To: <79759ec90902181549t292d1adco55416c04366afdad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Simpson wrote:
> I have an executable that loads shared libraries. I compiled with "-g
> -pg" and then I ran gprof on the gmon.out file. I don't see any of the
> shared libraries that the program loaded in my gprof output. How do
> you profile shared libraries?
> 
> Also, I saw on the ld.so man page the LD_PROFILE variable but I found
> information on the net that says variable should not be used when
> using -pg.
> 
> Can someone help me out? I can't find information *anywhere* on
> profiling shared libraries using gprof or the LD_PROFILE variable.
> 
> Sorry to post here. I don't know where else to post.

Can't really help you with gprof, but in most cases it's likely much 
easier to use oprofile instead, then you don't have to recompile your app..
