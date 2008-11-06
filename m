Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbYKFRLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbYKFRLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYKFRL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:11:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37006 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYKFRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:11:27 -0500
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <491321ED.5010103@redhat.com>
References: <20081106153022.215696930@redhat.com>
	 <1225986593.7803.4688.camel@twins> <20081106160154.GA7461@redhat.com>
	 <1225988173.7803.4723.camel@twins>  <20081106163957.GB7461@redhat.com>
	 <1225990327.7803.4776.camel@twins>  <491321ED.5010103@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2008 18:11:27 +0100
Message-Id: <1225991487.7803.4801.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 11:57 -0500, Rik van Riel wrote:
> Peter Zijlstra wrote:
> 
> > The only real issue I can see is with linear volumes, but those are
> > stupid anyway - non of the gains but all the risks.
> 
> Linear volumes may well be the most common ones.
> 
> People start out with the filesystems at a certain size,
> increasing onto a second (new) disk later, when more space
> is required.

Are they aware of how risky linear volumes are? I would discourage
anyone from using them.
