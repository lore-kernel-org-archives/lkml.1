Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbZEFArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbZEFArT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZEFArG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:47:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32917 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZEFArF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:47:05 -0400
Message-ID: <4A00DD4F.8010101@redhat.com>
Date: Tue, 05 May 2009 20:43:59 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses registrations.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com>
In-Reply-To: <1241475935-21162-3-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> subjects say it all.

Not a very useful commit message.

This makes me wonder, though.

What happens if a user mmaps a 30MB memory region, registers it
with KSM and then unmaps the middle 10MB?

> Signed-off-by: Izik Eidus <ieidus@redhat.com>

except for the commit message, Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
