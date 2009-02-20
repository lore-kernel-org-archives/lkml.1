Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZBTQXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZBTQXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZBTQWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:22:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35214 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZBTQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:22:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VtG7zoDUt8VWVKyxGshlj2fTAbB34tXmXlhu1fEB/ruCf8FwxobU0sbWsTD9Vqp5z
	R61nPwn4Q+FDC3h4ZLQ7A==
MIME-Version: 1.0
In-Reply-To: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 20 Feb 2009 08:22:45 -0800
Message-ID: <6599ad830902200822u6d453340me718bacac3925040@mail.gmail.com>
Subject: Re: Question for remount
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       lizf@cn.fujitsu.com, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 2:02 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> 2. /proc/mounts information of release_agent should be updated....
>   when it's overwritten directly.

Yes, definitely. But shouldn't that happen already?
cgroup_show_options() reports the current value of
root->release_agent_path in /proc/mounts. Is it possible that mount is
actually storing/retrieving this information in /etc/mtab, which
doesn't get updated?

Paul
