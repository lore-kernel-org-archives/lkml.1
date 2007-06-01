Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbXFATjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbXFATjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762797AbXFATjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:39:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762746AbXFATjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:39:14 -0400
Message-ID: <466075D1.8080807@redhat.com>
Date: Fri, 01 Jun 2007 15:38:57 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, andrew.vasquez@qlogic.com
Subject: Re: [PATCH] quiet down swiotlb warnings
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org> <20070601193703.GI7217@one.firstfloor.org>
In-Reply-To: <20070601193703.GI7217@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> An pci_map_sg failing typically leads to an IO error and we've
> always printk'ed those. Otherwise people will wonder why they
> get EIO.

In some situations.  In this case the qla2xxx driver uses
the pci_map_sg() failure as a throttling mechanism and
printing out all the warnings will actually slow down the
system.

Andi, what do you propose as a solution?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
