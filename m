Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYBPRk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYBPRk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYBPRkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:40:21 -0500
Received: from smtp-out.google.com ([216.239.45.13]:39892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYBPRkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:40:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=o1FdWpZNWqUz8D2gVkiFHhWW+vuQXvts6uyqwYqvCk8vEpCOyhV0tvXhQaPeMPI12
	C1FtVfis+OqurQOqnkxBA==
Message-ID: <6599ad830802160940g1221b9ebkc8d5bf795da59d38@mail.gmail.com>
Date: Sat, 16 Feb 2008 09:40:18 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 0/7] CGroup API: More structured API for CGroups control files
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, balbir@in.ibm.com,
       pj@sgi.com, "Pavel Emelianov" <xemul@openvz.org>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <47B6AD86.2060802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215204418.535025000@menage.corp.google.com>
	 <20080216132118.877e769b.kamezawa.hiroyu@jp.fujitsu.com>
	 <47B6AD86.2060802@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2008 1:31 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> I don't quite catch what you mean. Cgoup does support write-only/read-only
> files. For a write-only file, just set .write and .write_uint to be NULL,
> similar for a read-only file.
>
> Do I miss something?
>

I suppose we could infer from the lack of any write handlers that we
should give the file in the filesystem a mode of 444 rather 644.

Paul
