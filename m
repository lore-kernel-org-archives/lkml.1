Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbZHAOIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbZHAOIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 10:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZHAOIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 10:08:42 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45273 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZHAOIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 10:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bSht9o60pM5q0raP7SmIdoykwOgQG6hpAfm6VffdV9XDpLN6zq/c6mb6f3Lu68dfdd
         F1PR7lre+fa6XjeOaAUBBplwyUrHQrR/2NtjN3oearUrkQbjGusS7BdKvtjD8A6wt22e
         qlY52n4EjgCUWTc1bmJvfGo0l667rIx6G1ZXk=
Message-ID: <4A744C6C.3080908@gmail.com>
Date: Sat, 01 Aug 2009 16:08:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: memory-controller patch fails to boot in qemu [mmotm]
References: <4A744C2A.6040009@gmail.com>
In-Reply-To: <4A744C2A.6040009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2009 04:07 PM, Jiri Slaby wrote:
> Looks like an omitted unlock. I don't see anything suspicious in the
> patch though.

CONFIG_TREE_RCU=y
btw
