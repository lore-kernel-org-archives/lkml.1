Return-Path: <linux-kernel-owner+w=401wt.eu-S1760129AbYENBkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129AbYENBkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYENBkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:40:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYENBkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:40:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YdLxZ+JZD3r0n8ZU5rchgZcsUx4akPu2gqpcrK546a+z6RVrf6g4A+kl+3LLr0pG9
	d1bs0EIJJHszdzigI4Pbg==
Message-ID: <6599ad830805131840k543acb76o9a48ba140cc88159@mail.gmail.com>
Date: Tue, 13 May 2008 18:40:12 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC/PATCH 1/8]: CGroup Files: Add locking mode to cgroups control files
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <482A40C0.8030708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513063707.049448000@menage.corp.google.com>
	 <20080513071522.133586000@menage.corp.google.com>
	 <48295E11.2000003@cn.fujitsu.com>
	 <6599ad830805131407y3d94016cn773ba21a42b6098c@mail.gmail.com>
	 <482A40C0.8030708@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 6:30 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>  It's a bit odd to me that cgroup_is_removed() is removed in cgroup_file_write(),
>  but it's ressered here.
>

Fair point. It's probably better for me to be consistent.

Paul
