Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYHNVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYHNVQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYHNVQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:16:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58297 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYHNVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:16:34 -0400
Date: Thu, 14 Aug 2008 23:17:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080814211756.GC13814@one.firstfloor.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <1218747656.15342.439.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218747656.15342.439.camel@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 05:00:56PM -0400, Chris Mason wrote:
> Btrfs defaults                  57.41 MB/s
> Btrfs dup no csum               74.59 MB/s 

With duplications checksums seem to be quite costly (CPU bound?)

> Btrfs no duplication            76.83 MB/s
> Btrfs no dup no csum no inline  76.85 MB/s

But without duplication they are basically free here at least
in IO rate. Seems odd?

Does it compute them twice in the duplication case perhaps?

-Andi
