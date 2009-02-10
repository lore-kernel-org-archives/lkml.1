Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZBJALJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZBJALJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZBJAK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:10:56 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:50442 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZBJAKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:10:55 -0500
Message-ID: <4990C5F5.2050400@oracle.com>
Date: Mon, 09 Feb 2009 16:10:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] integrity: shmem zero fix
References: <1234220548-4791-1-git-send-email-zohar@linux.vnet.ibm.com> <8bd0f97a0902091603mbab4d50id9790658c5579c15@mail.gmail.com>
In-Reply-To: <8bd0f97a0902091603mbab4d50id9790658c5579c15@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4990C5E0.0267:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Mon, Feb 9, 2009 at 18:02, Mimi Zohar wrote:
>> Based on comments from Mike Frysinger and Randy Dunlap,
>> - moved ima.h include before CONFIG_SHMEM test
>> - added 'struct linux_binprm' in ima.h
> 
> please move the linux/fs.h include in linux/ima.h to match
> linux_binprm location while you're at it

Yes, that's the only difference with what I tested:

-#include <linux/fs.h>
-
 #ifndef _LINUX_IMA_H
 #define _LINUX_IMA_H
 
+#include <linux/fs.h>
+struct linux_binprm;
+




-- 
~Randy
