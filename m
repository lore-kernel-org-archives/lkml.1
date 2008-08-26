Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbYHZWoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbYHZWoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYHZWoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:44:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62595 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYHZWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:44:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=By3tPYwyQtDeU7ykhg0d7E4B41886ncOaktgryfK/NuvLIEvvmBPzjMtNHHCypuvu
	ujLGjMGHQtskliD5wl3uQ==
Message-ID: <6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>
Date: Tue, 26 Aug 2008 15:44:16 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <48B39319.7070403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B360CE.2010501@cn.fujitsu.com>
	 <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
	 <48B39319.7070403@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 10:22 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> It's complicated than necessary and change too much code IMO.

What about the problem that maintaining a single pid array can still
fail for a really large cgroup? I guess we could just say "don't
create such large cgroups" but someone's bound to want to do that.
Perhaps use an array of pages rather than a single large kmalloc?

Paul
