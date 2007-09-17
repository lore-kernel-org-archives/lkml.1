Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXIQSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXIQSIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXIQSIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:08:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57659 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbXIQSIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:08:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=u4tUOb7O/YXcpzXchRJJw1knD5IGYtZk3WeDGlIuYkWCnhMETRAnTAkd8n2pRciCr
	M7X/pxsUsV0G6wxYLsYIw==
Message-ID: <6599ad830709171108n2927d1fegcf05d564d4be0f6f@mail.gmail.com>
Date: Mon, 17 Sep 2007 11:08:03 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] task containersv11 enable containers by default in some configs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070915072904.30468.73201.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070915072904.30468.73201.sendpatchset@jackhammer.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Paul Menage - in pre-container cpusets, a few config files enabled
> cpusets by default.  Could you blend the following patch into your
> container patch set, so that cpusets continue to be configured by
> default for those same configurations?
>

OK, I'll take care of that.

After talking with akpm, it sounds as though some of the nasty aspects
of "select" in Kconfig rules can be avoided as long as no config
option is controlled by both "select" and "depends". So I'll probably
go back to making things like CONFIG_CPUSETS select CONFIG_CGROUPS,
and enforce that CONFIG_CGROUPS can't depend on anything.

Paul
