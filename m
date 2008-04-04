Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYDDJAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYDDJAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYDDJAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:00:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbYDDJA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:00:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=q+p4+x9uNRZiCi5uygLlm1VJ+ZRgCkZDKAwgrvGDlrqPdSrQCxsEcw4IOxEhOOeWn
	ACrmPPx28KKBuOJGc/1sA==
Message-ID: <6599ad830804040200u1ed48f4bxecaa664862cf30a5@mail.gmail.com>
Date: Fri, 4 Apr 2008 02:00:10 -0700
From: "Paul Menage" <menage@google.com>
To: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
Subject: Re: [RFC][patch 8/11][CFQ-cgroup] Control cfq_data per cgroup
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       axboe@kernel.dk, tom-sugawara@ap.jp.nec.com, m-takahashi@ex.jp.nec.com
In-Reply-To: <003401c8961c$00eea670$02cbf350$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>
	 <008501c893dc$3206e520$9614af60$@jp.nec.com>
	 <6599ad830804030835s73392db0v29426425c0ea4381@mail.gmail.com>
	 <003401c8961c$00eea670$02cbf350$@jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 11:20 PM, Satoshi UCHIDA <s-uchida@ap.jp.nec.com> wrote:
>
>  So that you say, root subsystem state maybe keep a reference locally.
>  For example, create a variable for root subsystem state and
>  store the pointer when making subsystem state first.

Yes, that's what I'm suggesting.

>
>  However, I think that it is smart to calculate root group of subsystems
>  when needing its information.

I don't see why it's better to go through the cgroup subsystem to
retrieve the reference.

Paul
