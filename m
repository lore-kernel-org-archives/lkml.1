Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYDCPfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYDCPfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbYDCPfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:35:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21351 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbYDCPfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:35:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=waalNQW8jDZp+hkYHDhX8JPrv+HDc4WeeMzHwRGXcQ5U68wfwSS4vnK78ZnaYv/Hk
	fyikYQovfhK8T2ZCMKA5w==
Message-ID: <6599ad830804030835s73392db0v29426425c0ea4381@mail.gmail.com>
Date: Thu, 3 Apr 2008 08:35:04 -0700
From: "Paul Menage" <menage@google.com>
To: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
Subject: Re: [RFC][patch 8/11][CFQ-cgroup] Control cfq_data per cgroup
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       axboe@kernel.dk, tom-sugawara@ap.jp.nec.com, m-takahashi@ex.jp.nec.com
In-Reply-To: <008501c893dc$3206e520$9614af60$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>
	 <008501c893dc$3206e520$9614af60$@jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2008 at 2:38 AM, Satoshi UCHIDA <s-uchida@ap.jp.nec.com> wrote:
>  +
>  +static void *cfq_cgroup_init_cfq_data(struct cfq_cgroup *cfqc, struct cfq_data *cfqd)
>  +{
>  +       struct cgroup *child;
>  +
>  +       /* setting cfq_data for cfq_cgroup */
>  +       if (!cfqc) {
>  +               cfqc = cgroup_to_cfq_cgroup(get_root_subsys(&cfq_cgroup_subsys));

Rather than adding get_root_subsys(), can't you just keep a reference
locally to your root subsystem state?

Paul
