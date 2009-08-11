Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZHKWLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZHKWLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZHKWLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:11:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbZHKWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:11:10 -0400
Date: Tue, 11 Aug 2009 15:10:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, hpa@zytor.com
Subject: Re: [PATCHv2 1/2] mm: export use_mm/unuse_mm to modules
Message-Id: <20090811151010.c9c56955.akpm@linux-foundation.org>
In-Reply-To: <20090811212752.GB26309@redhat.com>
References: <cover.1249992497.git.mst@redhat.com>
	<20090811212752.GB26309@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 00:27:52 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> vhost net module wants to do copy to/from user from a kernel thread,
> which needs use_mm (like what fs/aio has).  Move that into mm/ and
> export to modules.

OK by me.  Please include this change in the virtio patchset.  Which I
shall cheerfully not be looking at :)

