Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYFUILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYFUILq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYFUILb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:11:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45176 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYFUILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:11:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=chteCbe7tfdD/TadVaaTY1RgEXCLa4xEc5vjenoRoQjKgp3K5q63glHItDC14guwB
	rzfNZZr09zOzBQUsAt5MQ==
Message-ID: <6599ad830806210111o41ad8526j8490662ddf35f299@mail.gmail.com>
Date: Sat, 21 Jun 2008 01:11:24 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] Priority heap infrastructure enhancements
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <485CB652.90801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213796886-24863-1-git-send-email-balbir@linux.vnet.ibm.com>
	 <6599ad830806210029x2a020e1ava6b646be9913fcdf@mail.gmail.com>
	 <485CB652.90801@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 1:05 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> I would like to be able to drop the smallest value. Since we cannot drop the
> smallest value, dropping a leaf (heap->size) should be sufficiently good enough.
> I want a max heap and losing the root of the heap does not work for me.
>

What are you actually trying to do? Can you get round this by just
inverting your "gt" operator? i.e. provide one that actually
implements "less-than"?

Paul
